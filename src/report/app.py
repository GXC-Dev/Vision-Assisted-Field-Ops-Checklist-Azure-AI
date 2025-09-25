
from fastapi import FastAPI
from pydantic import BaseModel
from jinja2 import Template
from datetime import datetime

app = FastAPI(title="Report Generator")

TEMPLATE = Template("""
<html><body>
<h2>Inspection Report</h2>
<p><b>Asset:</b> {{ asset_id }} | <b>Date:</b> {{ date }}</p>
<h3>Detections</h3>
<ul>
{% for d in detections %}
<li>{{ d.label }} ({{ '%.0f' % (d.confidence*100) }}%)</li>
{% endfor %}
</ul>
<h3>SOP Summary</h3>
<ul>
{% for s in sop %}
<li><b>{{ s.defect }}</b> - {{ s.severity }}
  <ul>{% for st in s.steps %}<li>{{ st }}</li>{% endfor %}</ul>
</li>
{% endfor %}
</ul>
</body></html>
""")

class payload(BaseModel):
    asset_id: str
    detections: list
    sop: list

@app.post("/report/html")
def report_html(p: payload):
    html = TEMPLATE.render(asset_id=p.asset_id, detections=p.detections, sop=p.sop, date=datetime.utcnow().isoformat())
    return {"html": html}

@app.get("/healthz")
def health():
    return {"ok": True}
