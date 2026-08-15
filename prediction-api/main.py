import joblib
from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI()

# Charger le vrai modele de Meriem au demarrage de l'API
model = joblib.load("model.pkl")


# ===== B5 : Schema de la requete =====
class PredictionRequest(BaseModel):
    last_month_total: float = Field(..., ge=0, description="Doit etre positif ou nul")


# ===== B5 : Schema de la reponse =====
class PredictionResponse(BaseModel):
    prediction_available: bool
    predicted_next_month: float | None = None
    message: str | None = None


@app.post("/predict", response_model=PredictionResponse)
def predict(request: PredictionRequest):
    # B7 : pas assez d'historique -> pas de prediction inventee
    if request.last_month_total == 0:
        return PredictionResponse(
            prediction_available=False,
            message="Not enough spending history"
        )

    # Utilisation du vrai modele de Meriem
    prediction = model.predict([[request.last_month_total]])[0]
    return PredictionResponse(
        prediction_available=True,
        predicted_next_month=round(float(prediction), 2)
    )


# ===== B8 : Route de sante =====
@app.get("/health")
def health():
    return {"status": "ok"}
