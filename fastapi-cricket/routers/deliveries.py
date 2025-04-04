from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from crud import get_deliveries, create_delivery
from schemas import DeliverySchema

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/deliveries/")
def read_deliveries(db: Session = Depends(get_db)):
    return get_deliveries(db)

@router.post("/deliveries/")
def add_delivery(delivery: DeliverySchema, db: Session = Depends(get_db)):
    return create_delivery(db, delivery)