
from fastapi import FastAPI, UploadFile, File
from PIL import Image
import io

app = FastAPI(title="Vision Inference (stub)")

@app.post("/infer")
async def infer(file: UploadFile = File(...)):
    data = await file.read()
    _ = Image.open(io.BytesIO(data))
    # Fake detection result
    return {
        "detections": [
            {"label":"rust","confidence":0.88,"bbox":[0.1,0.2,0.5,0.6]},
            {"label":"missing_bolt","confidence":0.76,"bbox":[0.6,0.3,0.8,0.5]}
        ]
    }

@app.get("/healthz")
def health():
    return {"ok": True}
