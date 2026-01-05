# ==================================================
# BOOTSTRAP-ACASA.PS1
# Preenche arquivos com frontend funcional
# Projeto: ACASATOOLS
# ==================================================

Write-Host "Iniciando bootstrap do ACASATOOLS..." -ForegroundColor Green

function Write-File($path, $content) {
    $content | Out-File -Encoding UTF8 -Force $path
    Write-Host "Arquivo preenchido: $path" -ForegroundColor Cyan
}

# ---------------- package.json ----------------
Write-File "package.json" @"
{
  "name": "acasatools",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.2.1",
    "tailwindcss": "^3.4.0",
    "postcss": "^8.4.35",
    "autoprefixer": "^10.4.18"
  }
}
"@

# ---------------- index.html ----------------
Write-File "index.html" @"
<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ACASATOOLS</title>
  </head>
  <body class="bg-slate-900 text-slate-100">
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
"@

# ---------------- vite.config.js ----------------
Write-File "vite.config.js" @"
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
"@

# ---------------- tailwind.config.js ----------------
Write-File "tailwind.config.js" @"
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{js,jsx}',
    './pages/**/*.{js,jsx}',
    './components/**/*.{js,jsx}'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@

# ---------------- postcss.config.js ----------------
Write-File "postcss.config.js" @"
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
"@

# ---------------- styles/index.css ----------------
Write-File "styles/index.css" @"
@tailwind base;
@tailwind components;
@tailwind utilities;
"@

# ---------------- src/main.jsx ----------------
Write-File "src/main.jsx" @"
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import '../styles/index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
)
"@

# ---------------- src/App.jsx ----------------
Write-File "src/App.jsx" @"
import Layout from './Layout'
import Dashboard from '../pages/Dashboard'

export default function App() {
  return (
    <Layout>
      <Dashboard />
    </Layout>
  )
}
"@

# ---------------- src/Layout.jsx ----------------
Write-File "src/Layout.jsx" @"
export default function Layout({ children }) {
  return (
    <div className='min-h-screen bg-slate-900 text-slate-100'>
      <header className='p-4 border-b border-slate-700'>
        <h1 className='text-xl font-bold'>ACASATOOLS</h1>
        <p className='text-sm text-slate-400'>
          Mais do que trading, é a sua casa
        </p>
      </header>

      <main className='p-6'>
        {children}
      </main>
    </div>
  )
}
"@

# ---------------- pages/Dashboard.jsx ----------------
Write-File "pages/Dashboard.jsx" @"
export default function Dashboard() {
  return (
    <div className='space-y-4'>
      <h2 className='text-2xl font-semibold'>Dashboard</h2>
      <p className='text-slate-400'>
        Estrutura inicial do ACASATOOLS funcionando.
      </p>
    </div>
  )
}
"@

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " BOOTSTRAP FINALIZADO COM SUCESSO" -ForegroundColor Green
Write-Host " Agora rode: npm install && npm run dev" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Green