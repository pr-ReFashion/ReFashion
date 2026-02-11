import io
import os

from fastapi import FastAPI, UploadFile, File, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from starlette.responses import StreamingResponse

from rembg import remove

# Optional: keep the downloaded model inside this service folder (cleaner for dev)
os.environ.setdefault("U2NET_HOME", os.path.abspath("./.u2net"))

app = FastAPI(title="Image Processor", version="0.2.0")

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

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.post("/api/imageprocess")
async def imageprocess(
    file: UploadFile = File(...),
    # keep it simple: always returns a PNG with transparency
    matting: bool = Query(False),
):
    """
    Removes background and returns PNG with transparency (image/png).
    """
    inp = await file.read()
    if not inp:
        raise HTTPException(status_code=400, detail="Empty file")

    try:
        # alpha_matting can improve edges on hair/clothes, but can be slower
        out_bytes = remove(inp, alpha_matting=matting)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Background removal failed: {e}")

    return StreamingResponse(
        io.BytesIO(out_bytes),
        media_type="image/png",
        headers={
            "X-Processed": "background-removed",
            "X-Input-Filename": file.filename or "unknown",
        },
    )
