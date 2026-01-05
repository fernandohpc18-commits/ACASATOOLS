# ==================================================
# INIT-ACASA.PS1
# Projeto ACASATOOLS - Bootstrap inicial
# ==================================================

Write-Host "Iniciando setup do ACASATOOLS..." -ForegroundColor Green

# Verificar se é repositório Git
if (!(Test-Path ".git")) {
    Write-Host "ERRO: Execute este script dentro de um repositório Git." -ForegroundColor Red
    exit 1
}

# Funções seguras
function Ensure-Dir($path) {
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Pasta criada: $path" -ForegroundColor Cyan
    }
}

function Ensure-File($path, $content = "") {
    if (!(Test-Path $path)) {
        $content | Out-File -Encoding UTF8 -Force $path
        Write-Host "Arquivo criado: $path" -ForegroundColor Yellow
    }
}

# Estrutura de pastas
$dirs = @(
    "entities",
    "pages",
    "components",
    "components/trades",
    "components/market",
    "components/investment",
    "components/propfirm",
    "components/ui",
    "services",
    "utils",
    "hooks",
    "styles",
    "public",
    "src"
)

foreach ($d in $dirs) {
    Ensure-Dir $d
}

# Arquivos base
Ensure-File ".env.example"
Ensure-File "README.md" "# ACASATOOLS`nMais do que trading, é a sua casa"
Ensure-File "index.html" "<!DOCTYPE html><html lang='pt-BR'><body><div id='root'></div></body></html>"
Ensure-File "vite.config.js"
Ensure-File "tailwind.config.js"
Ensure-File "postcss.config.js"
Ensure-File "styles/index.css"
Ensure-File "src/main.jsx"
Ensure-File "src/App.jsx"
Ensure-File "src/Layout.jsx"
Ensure-File "pages/Dashboard.jsx"

# package.json (válido e simples)
Ensure-File "package.json" @"
{
  "name": "acasatools",
  "version": "1.0.0",
  "private": true
}
"@

# Entities
$entities = @(
    "PropFirm",
    "Trade",
    "TradeConfig",
    "AlertaTrade",
    "Ativo",
    "WatchlistItem",
    "AlertaAtivo",
    "AnaliseHistorico"
)

foreach ($e in $entities) {
    Ensure-File "entities/$e.json" "{}"
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " ACASATOOLS INICIALIZADO COM SUCESSO" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
