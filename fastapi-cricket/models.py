from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from database import Base

class Match(Base):
    __tablename__ = "matches"

    id = Column(Integer, primary_key=True, index=True)
    season = Column(String)
    city = Column(String)
    date = Column(String)
    match_type = Column(String)
    player_of_match = Column(String)
    venue = Column(String)
    team1 = Column(String)
    team2 = Column(String)
    toss_winner = Column(String)
    toss_decision = Column(String)
    winner = Column(String)
    result = Column(String)
    result_margin = Column(Integer)
    target_runs = Column(Integer)
    target_overs = Column(Integer)
    super_over = Column(Boolean)
    method = Column(String)
    umpire1 = Column(String)
    umpire2 = Column(String)

    # Relationship with Deliveries
    deliveries = relationship("Delivery", back_populates="match")


class Delivery(Base):
    __tablename__ = "deliveries"

    id = Column(Integer, primary_key=True, autoincrement=True)  # Primary key added
    match_id = Column(Integer, ForeignKey("matches.id"))  # Foreign key reference
    inning = Column(Integer)
    batting_team = Column(String)
    bowling_team = Column(String)
    over = Column(Integer)
    ball = Column(Integer)
    batter = Column(String)
    bowler = Column(String)
    non_striker = Column(String)
    batsman_runs = Column(Integer)
    extra_runs = Column(Integer)
    total_runs = Column(Integer)
    extras_type = Column(String)
    is_wicket = Column(Boolean)
    player_dismissed = Column(String)
    dismissal_kind = Column(String)
    fielder = Column(String)

    # Relationship with Match
    match = relationship("Match", back_populates="deliveries")