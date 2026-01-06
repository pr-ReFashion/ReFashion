# services/order_impact/main.py
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="order-impact")

class OrderPayload(BaseModel):
    order_id: str
    customer_id: str | None = None
    total: float | None = None

@app.get("/health")
def health():
    return {"service": "order-impact", "status": "ok"}

@app.post("/calc-impact")
def calc_impact(payload: OrderPayload):
    """
    Dummy logic: always return +1 for each metric.
    Later you can replace this with real AI/logic.
    """
    return {
        "co2_add": 5,
        "water_add": 5,
        "landfill_add": 5,
        "order_id": payload.order_id,
        "customer_id": payload.customer_id,
    }
