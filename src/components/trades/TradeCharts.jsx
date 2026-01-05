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
