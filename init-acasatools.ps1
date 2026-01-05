# ======================================================
# INIT-ACASATOOLS.PS1
# Setup completo + build GitHub Pages
# ======================================================

Write-Host "Inicializando ACASATOOLS..." -ForegroundColor Green

# ---------- NODE PORTABLE ----------
$NodePath = "C:\Users\Cooavil\Documents\PROGRAMAS\node_extract\PFiles64\nodejs"
$env:Path += ";$NodePath"

# ---------- VALIDACOES ----------
if (!(Test-Path ".git")) {
  Write-Host "ERRO: execute dentro de um repositório Git." -ForegroundColor Red
  exit 1
}

# ---------- HELPERS ----------
function MkDir($p) { if (!(Test-Path $p)) { New-Item -ItemType Directory $p | Out-Null } }
function MkFile($p, $c) { $c | Out-File -Encoding UTF8 -Force $p }

# ---------- PASTAS ----------
$dirs = @(
"src","pages","components","components/ui","styles","public"
)
$dirs | ForEach-Object { MkDir $_ }

# ---------- ARQUIVOS ----------
MkFile "index.html" @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>ACASATOOLS</title>
</head>
<body>
  <div id="root"></div>
  <script type="module" src="/src/main.jsx"></script>
</body>
</html>
"@

MkFile "styles/index.css" "@tailwind base;`n@tailwind components;`n@tailwind utilities;"

MkFile "src/main.jsx" @"
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import '../styles/index.css'

ReactDOM.createRoot(document.getElementById('root')).render(<App />)
"@

MkFile "src/App.jsx" @"
export default function App() {
  return (
    <div style={{ padding: 20 }}>
      <h1>ACASATOOLS</h1>
      <p>Mais do que trading, é a sua casa.</p>
    </div>
  )
}
"@

MkFile "vite.config.js" @"
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/ACASATOOLS/'
})
"@

MkFile "package.json" @"
{
  "name": "acasatools",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.2.1"
  }
}
"@

Write-Host "Instalando dependências..." -ForegroundColor Cyan
npm install

Write-Host "Gerando build..." -ForegroundColor Cyan
npm run build

Write-Host "Setup concluído com sucesso!" -ForegroundColor Green
Write-Host "Próximo passo: subir para o GitHub" -ForegroundColor Yellow
