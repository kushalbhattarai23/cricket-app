from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from crud import get_matches, create_match
from schemas import MatchSchema
from models import *
router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/matches/")
def read_matches(db: Session = Depends(get_db)):
    return get_matches(db)

@router.post("/matches/")
def add_match(match: MatchSchema, db: Session = Depends(get_db)):
    return create_match(db, match)
    
from sqlalchemy.orm import Session
from sqlalchemy import func

@router.get("/batting_data/")
def get_batting_data(db: Session = Depends(get_db)):
    # Step 1: Get match IDs without limit
    match_ids = db.query(Match.id).order_by(Match.id).subquery()

    # Step 2: Join Deliveries and filter by those match IDs, then get top batters without limit
    results = (
        db.query(
            Delivery.batter,
            func.sum(Delivery.batsman_runs).label("total_runs"),
            func.count(Delivery.ball).label("total_balls")  # Count balls
        )
        .join(match_ids, Delivery.match_id == match_ids.c.id)
        .group_by(Delivery.batter)
        .order_by(func.sum(Delivery.batsman_runs).desc())
        .all()  # Removed limit here to get all data
    )

    if results:
        return [
            {"batter": row[0], "total_runs": row[1], "total_balls": row[2]}
            for row in results
        ]
    else:
        return {"message": "No data found"}
