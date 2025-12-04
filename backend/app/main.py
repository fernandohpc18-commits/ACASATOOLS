from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="ACASA",
    description="MAIS DO QUE TRADING, É A SUA CASA",
    version="0.1.0",
)

origins = []

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins or ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health", tags=["health"])
async def health():
    return {"status": "ok", "app": "ACASA"}
