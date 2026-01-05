<#
PowerShell script: cria scaffold (Vite + React + Tailwind) e envia para repo remoto.
Usage:
  1) (Opcional) Exporte token temporário na sessão:
     $env:GITHUB_TOKEN = "ghp_ACASATOOLS"
  2) Abra PowerShell como usuário normal (não precisa instalar nada).
  3) Execute:
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
     & "C:\Users\Cooavil\ACASATOOLS\create_and_push_with_token.ps1"
Notes:
  - If $env:GITHUB_TOKEN is set the script will use it for push and will not store it.
  - If not set, git push will run normally (may prompt for credentials or use credential manager).
#>

param(
  [string]$RepoUrl = "https://github.com/pipocamen/ACASATOOLS.git",
  [string]$RepoPath = "C:\Users\Cooavil\ACASATOOLS",
  [string]$BranchName = "feature/web-app-from-script"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-TextFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  $content | Set-Content -Path $path -Encoding UTF8
  Write-Host "Wrote: $path"
}

# Verify git available
try {
  git --version > $null
} catch {
  Write-Error "Git não encontrado no PATH. Instale Git ou use um ambiente com git disponível."
  exit 1
}

# Ensure target folder exists; if not, clone or create
if (-not (Test-Path $RepoPath)) {
  Write-Host "RepoPath não existe. Tentando clonar em $RepoPath..."
  if ($env:GITHUB_TOKEN) {
    Write-Host "GITHUB_TOKEN detectado — clonando usando token (token NÃO será exibido)..."
    $authCloneUrl = $RepoUrl -replace '^https://','https://x-access-token:' + $env:GITHUB_TOKEN + '@'
    git clone $authCloneUrl $RepoPath
  } else {
    Write-Host "Sem token — clonando com URL pública (poderá solicitar credenciais)..."
    git clone $RepoUrl $RepoPath
  }
}

Set-Location $RepoPath

Write-Host "Fetching origin..."
git fetch origin

# Create or checkout branch
$remoteExists = $false
try {
  $ls = git ls-remote --heads origin $BranchName 2>$null
  if ($ls -and $ls.Trim() -ne "") { $remoteExists = $true }
} catch {
  # ignore
}

if ($remoteExists) {
  Write-Host "Remote branch existe. Fazendo checkout em branch local rastreada..."
  git checkout -B $BranchName origin/$BranchName
} else {
  Write-Host "Criando nova branch local $BranchName..."
  git checkout -B $BranchName
}

# Create directories
New-Item -ItemType Directory -Force -Path "src\components\trades" | Out-Null
New-Item -ItemType Directory -Force -Path "src\pages" | Out-Null
New-Item -ItemType Directory -Force -Path "src\data" | Out-Null
New-Item -ItemType Directory -Force -Path "src\styles" | Out-Null
New-Item -ItemType Directory -Force -Path ".github\workflows" | Out-Null

# Files contents (full scaffold)
$packageJson = @'
{
  "name": "acasatools-web",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "echo \"no linter configured\""
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.14.1",
    "sonner": "^2.0.0",
    "lucide-react": "^0.264.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.0.0",
    "tailwindcss": "^3.5.0",
    "postcss": "^8.4.0",
    "autoprefixer": "^10.4.0"
  }
}
'@

$viteConfig = @'
import { defineConfig } from "vite"
import react from "@vitejs/plugin-react"

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173
  }
})
'@

$tailwindConfig = @'
module.exports = {
  content: ["./index.html", "./src/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {}
  },
  plugins: []
}
'@

$postcssConfig = @'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {}
  }
}
'@

$indexHtml = @'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>ACASATOOLS — Web</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@

$mainJsx = @'
import React from "react"
import { createRoot } from "react-dom/client"
import { BrowserRouter } from "react-router-dom"
import App from "./App"
import "./styles/index.css"

createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
)
'@

$appJsx = @'
import React from "react"
import { Routes, Route, Link } from "react-router-dom"
import Dashboard from "./pages/Dashboard"
import TradeMonitor from "./pages/TradeMonitor"

export default function App() {
  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-slate-100">
      <header className="bg-white dark:bg-slate-800 shadow-sm">
        <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between">
          <h1 className="text-lg font-semibold">ACASATOOLS — Web</h1>
          <nav className="space-x-4">
            <Link to="/" className="text-sky-600 dark:text-sky-400">Dashboard</Link>
            <Link to="/trades" className="text-sky-600 dark:text-sky-400">Trade Monitor</Link>
          </nav>
        </div>
      </header>

      <main className="max-w-6xl mx-auto p-4">
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/trades" element={<TradeMonitor />} />
        </Routes>
      </main>
    </div>
  )
}
'@

$dashboardJsx = @'
import React from "react"

const samplePropFirms = [
  { id: 1, empresa: "AlphaProp", anos_atividade: 5, score_medio: 4.5, promocao_ativa: true },
  { id: 2, empresa: "BetaFunds", anos_atividade: 2, score_medio: 3.8, promocao_ativa: false },
  { id: 3, empresa: "SigmaTrading", anos_atividade: 8, score_medio: 4.9, promocao_ativa: true }
]

export default function Dashboard() {
  return (
    <div>
      <h2 className="text-2xl font-bold mb-4">Dashboard — PropFirms</h2>

      <section className="grid gap-4 md:grid-cols-3">
        {samplePropFirms.map(pf => (
          <div key={pf.id} className="bg-white dark:bg-slate-800 p-4 rounded-md shadow">
            <div className="flex items-center justify-between">
              <h3 className="font-semibold">{pf.empresa}</h3>
              <span className="text-sm text-slate-500 dark:text-slate-400">{pf.anos_atividade} anos</span>
            </div>
            <p className="mt-2">Score médio: <strong>{pf.score_medio}</strong></p>
            <p className="mt-1">Promoção ativa: {pf.promocao_ativa ? "Sim" : "Não"}</p>
          </div>
        ))}
      </section>

      <section className="mt-8">
        <h3 className="text-lg font-semibold mb-2">Resumo</h3>
        <div className="bg-white dark:bg-slate-800 p-4 rounded-md shadow">
          <p>Funcionalidades iniciais incluídas:</p>
          <ul className="list-disc ml-6 mt-2">
            <li>Listagem básica de PropFirms</li>
            <li>Rota / Dashboard e /trades (Trade Monitor)</li>
            <li>Componentes de métricas e gráficos (exemplo)</li>
          </ul>
        </div>
      </section>
    </div>
  )
}
'@

$tradeMonitorJsx = @'
import React from "react"
import sampleTrades from "../data/sampleTrades.json"
import TradeMetrics from "../components/trades/TradeMetrics"
import TradeCharts from "../components/trades/TradeCharts"

export default function TradeMonitor() {
  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold">Trade Monitor</h2>
        <div className="text-sm text-slate-500">Trades carregados: {sampleTrades.length}</div>
      </div>

      <TradeMetrics trades={sampleTrades} />

      <div className="mt-6">
        <TradeCharts trades={sampleTrades} />
      </div>
    </div>
  )
}
'@

$tradeMetricsJsx = @'
import React, { useMemo } from "react"

function formatUSD(v) {
  return v.toLocaleString("en-US", { style: "currency", currency: "USD" })
}

export default function TradeMetrics({ trades }) {
  const metrics = useMemo(() => {
    const total = trades.length
    const wins = trades.filter(t => t.resultado > 0).length
    const losses = trades.filter(t => t.resultado < 0).length
    const profit = trades.reduce((s, t) => s + t.resultado, 0)
    const best = trades.reduce((b, t) => (t.resultado > (b?.resultado ?? -Infinity) ? t : b), null)
    const worst = trades.reduce((w, t) => (t.resultado < (w?.resultado ?? Infinity) ? t : w), null)
    const winRate = total ? Math.round((wins / total) * 100) : 0
    return { total, wins, losses, profit, best, worst, winRate }
  }, [trades])

  return (
    <div className="grid gap-4 md:grid-cols-4">
      <div className="bg-white dark:bg-slate-800 p-4 rounded shadow">
        <div className="text-sm text-slate-500">Total Trades</div>
        <div className="text-xl font-bold">{metrics.total}</div>
      </div>

      <div className="bg-white dark:bg-slate-800 p-4 rounded shadow">
        <div className="text-sm text-slate-500">Win Rate</div>
        <div className="text-xl font-bold">{metrics.winRate}%</div>
      </div>

      <div className="bg-white dark:bg-slate-800 p-4 rounded shadow">
        <div className="text-sm text-slate-500">Lucro / Prejuízo</div>
        <div className={`text-xl font-bold ${metrics.profit >= 0 ? "text-emerald-600" : "text-rose-600"}`}>{formatUSD(metrics.profit)}</div>
      </div>

      <div className="bg-white dark:bg-slate-800 p-4 rounded shadow">
        <div className="text-sm text-slate-500">Melhor / Pior</div>
        <div className="text-sm mt-1">{metrics.best ? `${metrics.best.ativo} ${formatUSD(metrics.best.resultado)}` : "—"}</div>
        <div className="text-sm mt-1">{metrics.worst ? `${metrics.worst.ativo} ${formatUSD(metrics.worst.resultado)}` : "—"}</div>
      </div>
    </div>
  )
}
'@

$tradeChartsJsx = @'
import React from "react"

function SimpleBar({ value, max }) {
  const pct = max ? Math.max(2, Math.round((Math.abs(value) / max) * 100)) : 2
  const color = value >= 0 ? "bg-emerald-500" : "bg-rose-500"
  return (
    <div className="flex items-center space-x-3">
      <div className="w-28 text-sm text-slate-600">{value >= 0 ? `+${value}` : value}</div>
      <div className="flex-1 bg-slate-200 dark:bg-slate-700 h-4 rounded overflow-hidden">
        <div className={`${color} h-4`} style={{ width: `${pct}%` }} />
      </div>
    </div>
  )
}

export default function TradeCharts({ trades }) {
  const top = Math.max(...trades.map(t => Math.abs(t.resultado)), 0)
  const recent = trades.slice(-8).reverse()
  return (
    <div className="bg-white dark:bg-slate-800 p-4 rounded shadow">
      <h3 className="font-semibold mb-4">Últimos trades (simples)</h3>
      <div className="space-y-3">
        {recent.map(t => (
          <div key={t.id}>
            <div className="flex items-center justify-between text-sm mb-1">
              <div className="font-medium">{t.ativo} <span className="text-slate-500 ml-2 text-xs">{t.tipo}</span></div>
              <div className="text-slate-500 text-xs">{t.data}</div>
            </div>
            <SimpleBar value={t.resultado} max={top} />
          </div>
        ))}
      </div>
    </div>
  )
}
'@

$sampleTrades = @'
[
  { "id": "t1", "data": "2026-01-01", "ativo": "AAPL", "tipo": "compra", "quantidade": 10, "preco_entrada": 150, "preco_saida": 155, "resultado": 50 },
  { "id": "t2", "data": "2026-01-02", "ativo": "BTCUSD", "tipo": "venda", "quantidade": 0.01, "preco_entrada": 40000, "preco_saida": 39500, "resultado": -100 },
  { "id": "t3", "data": "2026-01-03", "ativo": "AAPL", "tipo": "compra", "quantidade": 5, "preco_entrada": 152, "preco_saida": 158, "resultado": 30 },
  { "id": "t4", "data": "2026-01-04", "ativo": "TSLA", "tipo": "compra", "quantidade": 2, "preco_entrada": 700, "preco_saida": 680, "resultado": -40 },
  { "id": "t5", "data": "2026-01-05", "ativo": "ETHUSD", "tipo": "compra", "quantidade": 0.2, "preco_entrada": 3000, "preco_saida": 3050, "resultado": 10 },
  { "id": "t6", "data": "2026-01-06", "ativo": "AAPL", "tipo": "venda", "quantidade": 3, "preco_entrada": 160, "preco_saida": 157, "resultado": -9 }
]
'@

$styles = @'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* small helpers */
body { @apply bg-slate-50 dark:bg-slate-900 }
'@

$gitignore = @'
node_modules
dist
.env
.vite
'@

$readme = @'
# ACASATOOLS — Web (Vite + React + Tailwind)

Scaffold inicial gerado a partir do SCRIPT do repositório.

Como rodar localmente:

1. Clone o repo e troque para a branch sugerida:
   - git fetch origin
   - git checkout -b feature/web-app-from-script origin/feature/web-app-from-script || git checkout -b feature/web-app-from-script

2. Instale:
   - npm install

3. Rode em modo desenvolvimento:
   - npm run dev

Pasta `src` contém:
- pages/ (Dashboard, TradeMonitor)
- components/trades (TradeMetrics, TradeCharts)
- data/sampleTrades.json (exemplo de dados)
'@

$ciYaml = @'
name: CI

on:
  push:
    branches: [ feature/web-app-from-script ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Use Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "20"

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build
'@

# Write files
Write-TextFile -path "package.json" -content $packageJson
Write-TextFile -path "vite.config.js" -content $viteConfig
Write-TextFile -path "tailwind.config.cjs" -content $tailwindConfig
Write-TextFile -path "postcss.config.cjs" -content $postcssConfig
Write-TextFile -path "index.html" -content $indexHtml
Write-TextFile -path "src\main.jsx" -content $mainJsx
Write-TextFile -path "src\App.jsx" -content $appJsx
Write-TextFile -path "src\pages\Dashboard.jsx" -content $dashboardJsx
Write-TextFile -path "src\pages\TradeMonitor.jsx" -content $tradeMonitorJsx
Write-TextFile -path "src\components\trades\TradeMetrics.jsx" -content $tradeMetricsJsx
Write-TextFile -path "src\components\trades\TradeCharts.jsx" -content $tradeChartsJsx
Write-TextFile -path "src\data\sampleTrades.json" -content $sampleTrades
Write-TextFile -path "src\styles\index.css" -content $styles
Write-TextFile -path ".gitignore" -content $gitignore
Write-TextFile -path "README.md" -content $readme
Write-TextFile -path ".github\workflows\ci.yml" -content $ciYaml

# Git add / commit
Write-Host "Staging files..."
git add .

Write-Host "Committing..."
try {
  git commit -m "feat(web): scaffold Vite + React + Tailwind + Dashboard/TradeMonitor (inicial)"
} catch {
  Write-Warning "No changes to commit or commit failed: $_"
}

# Push
if ($env:GITHUB_TOKEN) {
  Write-Host "GITHUB_TOKEN presente: usando token para push (não será gravado)..."
  $originalRemote = ""
  try {
    $originalRemote = git remote get-url origin 2>$null
  } catch {
    $originalRemote = $null
  }
  $authUrl = $RepoUrl -replace '^https://','https://x-access-token:' + $env:GITHUB_TOKEN + '@'
  Write-Host "Pushing via authenticated URL..."
  git push $authUrl "HEAD:refs/heads/$BranchName" --set-upstream
  if ($originalRemote) {
    Write-Host "Restaurando remote origin para o URL original..."
    git remote set-url origin $originalRemote
  }
} else {
  Write-Host "Sem token: fazendo push padrão (poderá solicitar credenciais)..."
  git push -u origin $BranchName
}

Write-Host "Concluído. Verifique a branch '$BranchName' no GitHub."
'```

Como executar (passo a passo)
1. Crie o arquivo acima em C:\Users\Cooavil\ACASATOOLS\create_and_push_with_token.ps1 (pode usar o Notepad).
2. (Opcional, recomendado) gere um PAT no GitHub com scope repo e copie.
3. Na mesma janela do PowerShell:
   - Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   - Para usar token (temporário): $env:GITHUB_TOKEN = "ghp_SeuTokenAqui"
   - Execute o script:
     & "C:\Users\Cooavil\ACASATOOLS\create_and_push_with_token.ps1"
4. Após executar, remova o token da sessão:
   Remove-Item Env:GITHUB_TOKEN

Se preferir que eu gere um .bat que execute tudo (sem PAT) ou uma versão que peça o token interativamente (sem deixá-lo no histórico), digo e adapto o script. Quer que eu também gere um comando para criar o PAT na interface do GitHub (passo-a-passo)?