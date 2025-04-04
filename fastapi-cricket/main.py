from fastapi import FastAPI
from database import engine, Base
import routers.matches as matches_router
import routers.deliveries as deliveries_router

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(matches_router.router, prefix="/matches", tags=["Matches"])
app.include_router(deliveries_router.router, prefix="/deliveries", tags=["Deliveries"])

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins (you can restrict this)
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allow all headers
)