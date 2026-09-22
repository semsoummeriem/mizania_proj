import joblib

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field


# ============================================================
# FastAPI application
# ============================================================

app = FastAPI(
    title="Mizania Prediction API",
    description="Machine learning API for predicting next month's spending.",
    version="1.0.0",
)


# ============================================================
# CORS configuration
# ============================================================
# Required for Flutter Web because the frontend and backend
# are running on different origins.
#
# "*" is suitable for development/testing.
# For production, replace it with your actual frontend URL.
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# Load the trained ML model
# ============================================================

model = joblib.load("model.pkl")


# ============================================================
# B5: Request schema
# ============================================================

class PredictionRequest(BaseModel):
    last_month_total: float = Field(
        ...,
        ge=0,
        description="Total spending from the previous month. Must be >= 0.",
    )


# ============================================================
# B5: Response schema
# ============================================================

class PredictionResponse(BaseModel):
    prediction_available: bool
    predicted_next_month: float | None = None
    message: str | None = None


# ============================================================
# Prediction endpoint
# ============================================================

@app.post("/predict", response_model=PredictionResponse)
def predict(request: PredictionRequest):

    # B7:
    # If there is no spending history, do not invent a prediction.
    if request.last_month_total == 0:
        return PredictionResponse(
            prediction_available=False,
            message="Not enough spending history",
        )

    # Use the trained ML model
    prediction = model.predict([[request.last_month_total]])[0]

    return PredictionResponse(
        prediction_available=True,
        predicted_next_month=round(float(prediction), 2),
    )


# ============================================================
# B8: Health check endpoint
# ============================================================

@app.get("/health")
def health():
    return {"status": "ok"}