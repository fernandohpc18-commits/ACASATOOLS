# ACASA — MAIS DO QUE TRADING, É A SUA CASA

ACASA é um ecossistema full-stack para Inteligência de Mercado, PropFirm Intelligence, Investimentos e IA, mantido no monorepo **ACASATOOLS**.

Principais módulos:
- ACASA PROPFIRMS (PropFirm Intelligence)
- ACASA MARKETS (Market Intelligence Engine)
- ACASA FUNDAMENTALS (Fundamental Analytics)
- ACASA INVEST (Investment Simulator)

## Stack

- Frontend: React + TypeScript, TailwindCSS, shadcn/ui, Recharts
- Backend: FastAPI (Python), PostgreSQL/TimescaleDB, Redis, WebSockets
- Infra: Docker, docker-compose

## Como rodar (dev)

1. Copie o arquivo \.env.example\ para \.env\ e ajuste as variáveis.
2. Construa as imagens:

   \\\ash
   docker compose build
   \\\

3. Suba os serviços:

   \\\ash
   docker compose up -d
   \\\

4. Acesse:
   - Frontend: http://localhost:3000
   - Backend docs: http://localhost:8000/docs
