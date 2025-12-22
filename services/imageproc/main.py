from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from starlette.responses import StreamingResponse, JSONResponse

app = FastAPI(title="Dummy Image Processor", version="0.1.0")

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

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.post("/api/imageprocess")
async def imageprocess(file: UploadFile = File(...)):
    """
    Echo the image back as-is.
    """
    content = await file.read()
    # Use incoming content type; default to octet-stream if missing
    mime = file.content_type or "application/octet-stream"
    return StreamingResponse(
        content=iter([content]),
        media_type=mime,
        headers={"X-Echo-Filename": file.filename or "unknown"},
    )
