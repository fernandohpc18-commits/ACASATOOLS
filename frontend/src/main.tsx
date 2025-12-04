import React from "react";
import ReactDOM from "react-dom/client";

const APP_NAME = "ACASA";
const APP_TAGLINE = "MAIS DO QUE TRADING, É A SUA CASA";

function App() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-900 text-slate-50">
      <div className="text-center space-y-2">
        <h1 className="text-3xl font-bold">{APP_NAME}</h1>
        <p className="text-sm opacity-80">{APP_TAGLINE}</p>
        <p className="text-xs opacity-60">Frontend inicial carregado com React + Vite.</p>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
