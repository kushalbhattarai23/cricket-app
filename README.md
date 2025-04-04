
# 🏏 Cricket Data Application

A full-stack Cricket data management app built with **FastAPI** for the backend and **Flutter** for the frontend. It allows you to store, retrieve, and visualize detailed match and delivery data for cricket games.

---

## 🧩 Tech Stack

- **Backend**: FastAPI, SQLAlchemy, PostgreSQL (or any SQL DB)
- **Frontend**: Flutter
- **ORM**: SQLAlchemy
- **Database Models**:
  - `Match`: Stores match-level data
  - `Delivery`: Stores ball-by-ball delivery data

---

## 🗂 Project Structure

```
cricket_app/
│
├── backend/
│   ├── main.py               # FastAPI entry point
│   ├── models.py             # SQLAlchemy models (Match, Delivery)
│   ├── crud.py               # DB operations
│   ├── schemas.py            # Pydantic schemas
│   ├── database.py           # DB connection setup
│   └── routers/
│       └── matches.py        # API endpoints
│
├── frontend/
│   └── cricket_app/          # Flutter project
│       ├── lib/
│       │   ├── main.dart
│       │   ├── screens/
│       │   └── services/
│       └── pubspec.yaml
│
└── README.md
```

---



## 🚀 How to Run

### Backend (FastAPI)

1. **Install dependencies**  
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

2. **Run the FastAPI server**  
   ```bash
   uvicorn main:app --reload
   ```

3. **Docs available at**  
   [http://localhost:8000/docs](http://localhost:8000/docs)

---

### Frontend (Flutter)

1. **Navigate to Flutter directory**  
   ```bash
   cd frontend/cricket_app
   ```

2. **Install dependencies**  
   ```bash
   flutter pub get
   ```

3. **Run the app**  
   ```bash
   flutter run
   ```

---

## 📡 API Endpoints (Sample)

- `GET /matches/` — Get all matches
- `GET /matches/{id}` — Get match by ID
- `POST /matches/` — Add a new match
- `GET /deliveries/` — Get all deliveries
- `POST /deliveries/` — Add a delivery

---

## 📌 Features

- Ball-by-ball delivery tracking
- Match summary and metadata
- Toss and result information
- Flutter UI for data visualization

---

## 🔧 TODO

- [ ] Add authentication
- [ ] Match statistics dashboard in Flutter
- [ ] Graphs for player performance
- [ ] Admin panel
- [ ] Match summary and metadata
- [ ] Toss and result information
- [ ] Flutter UI for data visualization
---


## 📃 License

This project is licensed under the MIT License.
