from sqlalchemy.orm import Session
from models import Match, Delivery
from schemas import MatchSchema, DeliverySchema

def get_matches(db: Session):
    return db.query(Match).limit(10).all()

def create_match(db: Session, match: MatchSchema):
    db_match = Match(**match.dict())
    db.add(db_match)
    db.commit()
    return db_match

def get_deliveries(db: Session):
    return db.query(Delivery).limit(10).all()


def create_delivery(db: Session, delivery: DeliverySchema):
    db_delivery = Delivery(**delivery.dict())
    db.add(db_delivery)
    db.commit()
    return db_delivery