import os
import json
import time
import tempfile
import threading
from typing import List, Optional, Dict
from urllib.parse import urlparse, parse_qs, unquote

import requests
from fastapi import FastAPI, File, UploadFile, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from bs4 import BeautifulSoup

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Firefox
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.firefox.service import Service as FirefoxService
from webdriver_manager.firefox import GeckoDriverManager

# Chrome (optional fallback)
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager


# ---------------- config ----------------
HEADLESS = os.getenv("HEADLESS", "true").lower() != "false"
VIS_DEBUG = os.getenv("VIS_DEBUG", "false").lower() == "true"
VIS_BROWSER = os.getenv("VIS_BROWSER", "firefox").lower()  # firefox | chrome

# Persist cookies to reduce repeated consent banners
PERSIST_PROFILE = os.getenv("PERSIST_PROFILE", "true").lower() == "true"
FIREFOX_PROFILE_DIR = os.getenv("FIREFOX_PROFILE_DIR", os.path.abspath("./.firefox-profile"))

DEFAULT_MAX_RESULTS = int(os.getenv("VIS_MAX_RESULTS", "5"))
REQUEST_TIMEOUT = float(os.getenv("VIS_HTTP_TIMEOUT", "8"))
SCRAPE_MAX_CHARS = int(os.getenv("SCRAPE_MAX_CHARS", "2400"))

UA = os.getenv(
    "VIS_UA",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/120 Safari/537.36",
)

# Selenium must be serialized (drivers can crash under concurrent calls)
SEL_LOCK = threading.Lock()
_DRIVER: Optional[webdriver.Remote] = None

app = FastAPI(title="VisualSearch Service (Bing)", version="0.7.0")

# Allow only your local frontends (adjust if needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:9000",  # Medusa admin
        "http://localhost:5173",  # vendor panel
        "http://localhost:3000",  # storefront (if needed)
    ],
    allow_credentials=True,
    allow_methods=["POST", "GET", "OPTIONS"],
    allow_headers=["*"],
)


def _dbg(msg: str):
    if VIS_DEBUG:
        print(msg, flush=True)


# ---------------- URL cleanup ----------------
def _fix_url(u: str) -> str:
    u = (u or "").strip()
    if not u:
        return ""
    # decode repeated encoding a few times
    for _ in range(3):
        if u.startswith("http%3A") or u.startswith("https%3A") or "%2f" in u.lower():
            u2 = unquote(u)
            if u2 == u:
                break
            u = u2
        else:
            break
    u = u.strip()
    if u.startswith("http://") or u.startswith("https://"):
        return u
    return ""


def _decode_bing_aclick(href: str) -> str:
    """If href is https://www.bing.com/aclick?... decode u= if present."""
    try:
        p = urlparse(href)
        if "bing.com" not in p.netloc.lower() or not p.path.startswith("/aclick"):
            return href
        qs = parse_qs(p.query)
        if "u" not in qs or not qs["u"]:
            return href
        # u= is usually base64-url; sometimes plain urlencoded; try both
        cand = qs["u"][0]
        cand = _fix_url(cand) or _fix_url(unquote(cand))
        return cand or href
    except Exception:
        return href


def _normalize_outbound_url(href: str) -> str:
    href = _fix_url(href) or (href or "").strip()
    if not href:
        return ""
    href = _decode_bing_aclick(href)
    href = _fix_url(href) or href

    # if bing wraps url= or r=
    try:
        p = urlparse(href)
        qs = parse_qs(p.query)
        for k in ("url", "r"):
            if k in qs and qs[k]:
                cand = _fix_url(unquote(qs[k][0]))
                if cand:
                    return cand
    except Exception:
        pass

    return href


def _is_bing_internal(url: str) -> bool:
    u = _fix_url(url) or (url or "")
    if not u:
        return True
    host = urlparse(u).netloc.lower()
    return host.endswith("bing.com") or host.endswith("microsoft.com")


def _dedupe(items: List[dict], key: str) -> List[dict]:
    seen = set()
    out = []
    for it in items:
        v = (it.get(key) or "").strip()
        if not v or v in seen:
            continue
        seen.add(v)
        out.append(it)
    return out


# ---------------- driver lifecycle (self-healing) ----------------
def _make_firefox() -> webdriver.Firefox:
    opts = FirefoxOptions()
    opts.headless = HEADLESS

    if PERSIST_PROFILE:
        os.makedirs(FIREFOX_PROFILE_DIR, exist_ok=True)
        opts.add_argument("-profile")
        opts.add_argument(FIREFOX_PROFILE_DIR)

    service = FirefoxService(GeckoDriverManager().install())
    d = webdriver.Firefox(service=service, options=opts)
    d.set_page_load_timeout(60)
    return d


def _make_chrome() -> webdriver.Chrome:
    opts = ChromeOptions()
    if HEADLESS:
        opts.add_argument("--headless=new")
    opts.add_argument("--window-size=1400,900")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--disable-dev-shm-usage")
    service = ChromeService(ChromeDriverManager().install())
    d = webdriver.Chrome(service=service, options=opts)
    d.set_page_load_timeout(60)
    return d


def _build_driver() -> webdriver.Remote:
    if VIS_BROWSER == "chrome":
        return _make_chrome()
    return _make_firefox()


def _driver_alive(d: webdriver.Remote) -> bool:
    try:
        _ = d.current_url
        return True
    except Exception:
        return False


def _get_driver() -> webdriver.Remote:
    global _DRIVER
    if _DRIVER is None or not _driver_alive(_DRIVER):
        if _DRIVER is not None:
            try:
                _DRIVER.quit()
            except Exception:
                pass
        _dbg("Driver: creating new session")
        _DRIVER = _build_driver()
    return _DRIVER


def _reset_driver():
    global _DRIVER
    if _DRIVER is not None:
        try:
            _DRIVER.quit()
        except Exception:
            pass
    _DRIVER = None


# ---------------- Bing automation (no Web Search clicks) ----------------
def _wait_dom_ready(driver: webdriver.Remote, timeout: float = 12.0):
    WebDriverWait(driver, timeout).until(
        lambda d: d.execute_script("return document.readyState") in ("interactive", "complete")
    )


def _accept_bing_cookies(driver: webdriver.Remote):
    for css in ("#bnp_btn_accept", "button#bnp_btn_accept", "input#bnp_btn_accept"):
        try:
            el = WebDriverWait(driver, 2).until(EC.element_to_be_clickable((By.CSS_SELECTOR, css)))
            driver.execute_script("arguments[0].click();", el)
            _dbg(f"Cookies: accepted via {css}")
            return
        except Exception:
            pass


def _open_bing_camera(driver: webdriver.Remote):
    for css in (
        "#sbi_b", "a#sbi_b", "button#sbi_b",
        "a[aria-label*='Search using an image']", "button[aria-label*='Search using an image']",
        "a[aria-label*='image']", "button[aria-label*='image']",
    ):
        try:
            el = WebDriverWait(driver, 2).until(EC.element_to_be_clickable((By.CSS_SELECTOR, css)))
            _dbg(f"Camera: clicking {css}")
            driver.execute_script("arguments[0].click();", el)
            return
        except Exception:
            pass


def _bing_upload(driver: webdriver.Remote, image_path: str):
    driver.get("https://www.bing.com/images?setlang=en")
    _wait_dom_ready(driver, 12)
    _accept_bing_cookies(driver)
    time.sleep(0.2)

    _open_bing_camera(driver)
    time.sleep(0.25)

    input_el = None
    for sel in ("input#sb_fileinput", "input[name='sb_fileinput'][type='file']", "input[type='file']"):
        try:
            input_el = WebDriverWait(driver, 8).until(EC.presence_of_element_located((By.CSS_SELECTOR, sel)))
            _dbg(f"Upload input found: {sel}")
            break
        except Exception:
            input_el = None
    if not input_el:
        raise RuntimeError("Bing upload input not found")

    input_el.send_keys(image_path)

    WebDriverWait(driver, 25).until(
        lambda d: ("SBIUPLOAD" in d.current_url.upper()) or ("detailv2" in d.current_url.lower())
    )
    time.sleep(0.8)
    _accept_bing_cookies(driver)

    # small scroll to hydrate DOM
    driver.execute_script("window.scrollBy(0, 900);")
    time.sleep(0.25)
    driver.execute_script("window.scrollBy(0, 900);")
    time.sleep(0.25)

    _dbg(f"Bing: landed url={driver.current_url}")


def _try_click_pages(driver: webdriver.Remote) -> bool:
    xps = [
        "//button[normalize-space()='Pages']",
        "//a[normalize-space()='Pages']",
        "//*[@role='tab' and normalize-space()='Pages']",
        "//*[self::button or self::a or self::span][contains(normalize-space(.),'Pages')]",
    ]
    for xp in xps:
        try:
            el = WebDriverWait(driver, 2).until(EC.element_to_be_clickable((By.XPATH, xp)))
            driver.execute_script("arguments[0].click();", el)
            time.sleep(0.7)
            _dbg("Bing: Pages clicked")
            return True
        except Exception:
            pass
    return False


def _extract_looks_like_title(driver: webdriver.Remote) -> Optional[str]:
    """
    Extract the 'Looks like' title (e.g. 'Nike Windbreaker Jacket') from the right panel.
    No clicks, just DOM reading.
    """
    js = r"""
    function clean(t){ return (t||"").replace(/\s+/g," ").trim(); }

    // Find a leaf node whose text is exactly 'Looks like'
    const leaf = Array.from(document.querySelectorAll("*"))
      .find(e => e.children.length === 0 && clean(e.innerText) === "Looks like");
    if (!leaf) return null;

    // Usually the query text lives in the same row/container
    // Walk up a bit and search for the best adjacent text
    let container = leaf;
    for (let i = 0; i < 6; i++) {
      if (!container) break;

      const texts = [];
      // Prefer anchors first (often the query is a link)
      container.querySelectorAll("a, span, div").forEach(el => {
        const t = clean(el.innerText);
        if (!t) return;
        if (t === "Looks like") return;
        // filter obvious UI labels
        if (t === "Images" || t === "Web Search") return;
        texts.push(t);
      });

      // pick the best candidate: reasonable length and not huge
      const cand = texts
        .filter(t => t.length >= 3 && t.length <= 80)
        .sort((a,b) => b.length - a.length)[0];

      if (cand) return cand;

      container = container.parentElement;
    }
    return null;
    """
    try:
        val = driver.execute_script(js)
        val = (val or "").strip()
        return val or None
    except Exception:
        return None


def _extract_external_links_anywhere(driver: webdriver.Remote, max_results: int) -> List[Dict[str, str]]:
    anchors = driver.find_elements(By.CSS_SELECTOR, "a[href]")
    out: List[Dict[str, str]] = []
    for a in anchors:
        href = _normalize_outbound_url(a.get_attribute("href") or "")
        if not href or _is_bing_internal(href):
            continue

        # avoid direct image files
        if any(href.lower().endswith(ext) for ext in (".jpg", ".jpeg", ".png", ".webp", ".gif")):
            continue

        title = (a.text or "").strip()
        out.append({"source": "bing_links", "url": href, "title": title or href, "image_thumb": ""})

        if len(out) >= max_results * 8:
            break

    out = _dedupe(out, "url")[:max_results]
    _dbg(f"Bing: external links extracted={len(out)}")
    return out


def _extract_pages(driver: webdriver.Remote, max_results: int) -> List[Dict[str, str]]:
    # Try Pages UI first, then fallback to any outbound links
    if _try_click_pages(driver):
        return _extract_external_links_anywhere(driver, max_results)
    _dbg("Bing: Pages tab not found; using fallback link extraction")
    return _extract_external_links_anywhere(driver, max_results)


def _extract_insights(driver: webdriver.Remote, max_results: int) -> List[Dict[str, str]]:
    imgs = driver.find_elements(By.CSS_SELECTOR, "img")
    out: List[Dict[str, str]] = []

    for img in imgs:
        try:
            src = (img.get_attribute("src") or "").strip()
            if not src.startswith("http") or src.startswith("data:image"):
                continue

            # insights images are usually on the right side; quick heuristic
            rect = img.rect or {}
            if float(rect.get("x", 0.0)) < 420 or float(rect.get("width", 0.0)) < 80:
                continue

            href = driver.execute_script(
                "const el=arguments[0]; const a=el.closest('a[href]'); return a ? a.href : null;",
                img,
            )
            if not href:
                continue

            href = _normalize_outbound_url(href)
            if not href:
                continue

            title = (img.get_attribute("alt") or "").strip() or href
            out.append({"source": "bing_insights", "url": href, "title": title, "image_thumb": src})

            if len(out) >= max_results:
                break
        except Exception:
            continue

    out = _dedupe(out, "image_thumb")[:max_results]
    _dbg(f"Bing: insights extracted={len(out)}")
    return out


# ---------------- scraping (requests only; no extra windows) ----------------
def _http_get(url: str) -> Optional[requests.Response]:
    try:
        return requests.get(url, headers={"User-Agent": UA}, timeout=REQUEST_TIMEOUT, allow_redirects=True)
    except Exception:
        return None


def _extract_text(html: str) -> str:
    soup = BeautifulSoup(html, "lxml")

    title = (soup.title.get_text(" ", strip=True) if soup.title else "").strip()
    desc = ""
    md = soup.find("meta", attrs={"name": "description"})
    if md and md.get("content"):
        desc = md.get("content", "").strip()

    ogt = ""
    ogd = ""
    m1 = soup.find("meta", attrs={"property": "og:title"})
    m2 = soup.find("meta", attrs={"property": "og:description"})
    if m1 and m1.get("content"):
        ogt = m1.get("content", "").strip()
    if m2 and m2.get("content"):
        ogd = m2.get("content", "").strip()

    # remove noisy nodes
    for tag in soup(["script", "style", "noscript", "svg"]):
        tag.decompose()

    body = soup.get_text("\n", strip=True)
    body = "\n".join([ln for ln in body.splitlines() if len(ln.strip()) > 2])[:SCRAPE_MAX_CHARS]

    parts = []
    if title:
        parts.append(f"TITLE: {title}")
    if desc:
        parts.append(f"DESCRIPTION: {desc}")
    if ogt:
        parts.append(f"OG_TITLE: {ogt}")
    if ogd:
        parts.append(f"OG_DESCRIPTION: {ogd}")
    if body:
        parts.append("BODY_TEXT:\n" + body)

    return "\n".join(parts).strip()


def _scrape(url: str) -> Dict[str, str]:
    url = _normalize_outbound_url(url)
    if not url:
        return {"url": "", "final_url": "", "text": ""}

    r = _http_get(url)
    if not r or not getattr(r, "text", ""):
        return {"url": url, "final_url": "", "text": ""}

    final_url = str(getattr(r, "url", "") or "")
    text = _extract_text(r.text)

    return {"url": url, "final_url": final_url, "text": text}


# ---------------- API ----------------
class SearchResponse(BaseModel):
    provider: str
    results: List[dict]
    insights: List[dict]
    scraped: List[dict]
    looks_like: Optional[str] = None
    error: Optional[str] = None



@app.post("/visual-search", response_model=SearchResponse)
def visual_search(
    file: UploadFile = File(...),
    provider: str = Query("bing", pattern="^bing$"),
    scrape: bool = Query(True),
    max_results: int = Query(DEFAULT_MAX_RESULTS, ge=1, le=10),
):
    with tempfile.NamedTemporaryFile(suffix=".jpg", delete=False) as tmp:
        content = file.file.read()
        tmp.write(content)
        tmp.flush()
        img_path = tmp.name

    def _run_once() -> SearchResponse:
        with SEL_LOCK:
            driver = _get_driver()
            _bing_upload(driver, img_path)

            looks_like = _extract_looks_like_title(driver)  # <--- add this

            pages = _extract_pages(driver, max_results)
            insights = _extract_insights(driver, max_results)


        # If Pages failed, use Insights as results so you always get something
        results = pages if pages else insights
        results = _dedupe(results, "url")[:max_results]
        insights = _dedupe(insights, "image_thumb")[:max_results]

        scraped_items: List[dict] = []
        err = None

        if scrape and results:
            for r in results[:max_results]:
                u = r.get("url") or ""
                if not u or _is_bing_internal(u):
                    continue
                s = _scrape(u)
                if (s.get("text") or "").strip():
                    scraped_items.append(s)

        if not results and not insights:
            err = "No results extracted (Bing UI changed/blocked)."
        elif scrape and results and not scraped_items:
            err = "Got results but scraped text is empty (many sites are JS/login/cookie heavy)."

        return SearchResponse(provider="bing", results=results, insights=insights, scraped=scraped_items, looks_like=looks_like, error=err)

    try:
        # Try once; if marionette died, reset driver and retry once.
        try:
            return _run_once()
        except Exception as e1:
            msg1 = str(e1)
            if "marionette" in msg1.lower() or "invalidsession" in msg1.lower() or "failed to decode" in msg1.lower():
                _dbg(f"Driver crashed, resetting and retrying once: {msg1}")
                _reset_driver()
                return _run_once()
            raise

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content=SearchResponse(provider="bing", results=[], insights=[], scraped=[], error=str(e)).model_dump(),
        )
    finally:
        try:
            os.remove(img_path)
        except Exception:
            pass


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=9300)
