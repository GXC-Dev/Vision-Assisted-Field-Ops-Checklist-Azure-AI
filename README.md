
# Vision-Assisted Field Ops Checklist
Field technicians upload photos of assets. The system detects defects, retrieves SOP steps, and generates a simple report — production patterns ready.

## Features
- Vision inference (stubbed YOLO/ONNX hook) -> defect labels + confidence
- SOP retrieval (RAG stub) -> steps per defect + severity
- Report generator (HTML) -> one-pager you can PDF later
- Azure infra (storage, search, cosmos placeholders, web apps)
- Smoke tests and placeholders to expand

## Quick Start (local stubs)
```bash
# In three terminals
uvicorn src.infer.app:app --host 0.0.0.0 --port 8001
uvicorn src.rag.app:app   --host 0.0.0.0 --port 8002
uvicorn src.report.app:app --host 0.0.0.0 --port 8003
```

Then POST an image to `/infer`, pipe detections to `/sop`, then `/report/html` to render an HTML summary.

## Deploy (infra)
```powershell
pwsh ./deploy/deploy.ps1
```
This sets up Storage, Search, Cosmos (account), and three Linux Web Apps.

## Roadmap
- Replace stubs: wire Azure AI Vision and Azure AI Search
- Add Cosmos containers: `assets`, `inspections`, `defects`
- Add PWA camera app (offline-first) and Event Grid ingestion
- Observability with App Insights, RBAC, privacy/retention

## Repo Layout
```
deploy/     # bicep + deploy script
src/infer/  # inference service (stub)
src/rag/    # RAG service (stub)
src/report/ # report service
src/webapp/ # PWA placeholder
tools/      # seeders & simulators (placeholders)
tests/      # smoke tests
```

## License
MIT
