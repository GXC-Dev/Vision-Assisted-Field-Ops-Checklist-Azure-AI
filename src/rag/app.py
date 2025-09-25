
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="SOP RAG Service (stub)")

class Query(BaseModel):
    defects: list

@app.post("/sop")
def sop(q: Query):
    steps = []
    for d in q.defects:
        label = d.get("label","defect")
        steps.append({
            "defect": label,
            "severity": "CRITICAL" if label in ("crack","leaning_pole") else "MODERATE",
            "steps": [
                "Isolate equipment if safety risk.",
                "Photograph defect from 3 angles.",
                "Create work order and attach evidence."
            ]
        })
    return {"sop": steps}

@app.get("/healthz")
def health():
    return {"ok": True}
