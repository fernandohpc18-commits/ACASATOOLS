import React from 'react'
import { Routes, Route, Link } from 'react-router-dom'
import Dashboard from './pages/Dashboard'
import TradeMonitor from './pages/TradeMonitor'

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
