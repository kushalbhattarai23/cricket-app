from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
from crud import get_matches, create_match
from schemas import MatchSchema
from models import *
from sqlalchemy import func, distinct, or_

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


@router.get("/bowling_data/")
def get_bowling_data(db: Session = Depends(get_db)):
    # Step 1: Get match IDs
    match_ids = db.query(Match.id).order_by(Match.id).subquery()

    # Step 2: Join and calculate wickets (excluding run outs)
    results = (
        db.query(
            Delivery.bowler,
            func.count().label("total_wickets")
        )
        .filter(Delivery.match_id.in_(match_ids))
        .filter(Delivery.player_dismissed != None)
        .filter(Delivery.dismissal_kind != 'run out')
        .group_by(Delivery.bowler)
        .order_by(func.count().desc())
        .all()
    )

    if results:
        return [
            {"bowler": row[0], "total_wickets": row[1]}
            for row in results
        ]
    else:
        return {"message": "No data found"}



@router.get("/teams/stats/")
def get_teams_stats(db: Session = Depends(get_db)):
    # Get all distinct teams from team1 (only team1, not team2)
    teams = db.query(Match.team1).distinct().all()

    team_stats = []
    
    for team_tuple in teams:
        team = team_tuple[0]
        
        # Count matches played by this team
        matches_played = db.query(func.count()).filter(Match.team1 == team).scalar()

        team_stats.append({
            "teamname": team,
            "played": matches_played
        })

    return team_stats




@router.get("/players/stats/")
def get_players_stats(db: Session = Depends(get_db)):
    players = db.query(distinct(Delivery.batter)).union(
        db.query(distinct(Delivery.bowler)),
        db.query(distinct(Delivery.fielder))
    ).all()

    player_stats = []

    for player_tuple in players:
        player = player_tuple[0]

        # Match count
        match_ids_subq = db.query(distinct(Delivery.match_id)).filter(
            or_(
                Delivery.batter == player,
                Delivery.bowler == player,
                Delivery.fielder == player
            )
        ).subquery()

        match_count = db.query(func.count()).select_from(match_ids_subq).scalar()

        # Teams played for (based on role)
        batting_teams = db.query(distinct(Delivery.batting_team)).filter(
            Delivery.batter == player
        )

        bowling_teams = db.query(distinct(Delivery.bowling_team)).filter(
            Delivery.bowler == player
        )

        teams = batting_teams.union(bowling_teams).all()
        team_names = list(set([t[0] for t in teams]))

        # Batting
        batting_data = db.query(
            func.sum(Delivery.batsman_runs),
            func.count(Delivery.ball)
        ).filter(Delivery.batter == player).first()
        total_runs = batting_data[0] or 0
        total_balls = batting_data[1] or 0
        strike_rate = (total_runs / total_balls * 100) if total_balls > 0 else 0

        # Bowling
        total_wickets = db.query(func.count()).filter(
            Delivery.bowler == player,
            Delivery.player_dismissed != None,
            Delivery.dismissal_kind != 'run out'
        ).scalar() or 0

        # Fielding
        catches = db.query(func.count()).filter(
            Delivery.fielder == player,
            Delivery.dismissal_kind == 'caught'
        ).scalar() or 0

        runouts = db.query(func.count()).filter(
            Delivery.fielder == player,
            Delivery.dismissal_kind == 'run out'
        ).scalar() or 0

        # Color classification
        if total_runs >= 300 and total_wickets >= 10:
            role = "All-Rounder"
            color = "#FFD700"  # Gold
        elif total_runs >= 300:
            role = "Batter"
            color = "#00BFFF"  # DeepSkyBlue
        elif total_wickets >= 10:
            role = "Bowler"
            color = "#32CD32"  # LimeGreen
        else:
            role = "Other"
            color = "#D3D3D3"  # LightGray

        player_stats.append({
            "player": player,
            "teams": team_names,
            "matches_played": match_count,
            "total_runs": total_runs,
            "total_wickets": total_wickets,
            "strike_rate": round(strike_rate, 2),
            "catches": catches,
            "runouts": runouts,
            "role": role,
            "color": color
        })

    return player_stats
