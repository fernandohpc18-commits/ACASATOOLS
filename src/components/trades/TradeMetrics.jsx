import React, { useMemo } from 'react'

function formatUSD(v) {
  return v.toLocaleString('en-US', { style: 'currency', currency: 'USD' })
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
        <div className={`text-xl font-bold ${metrics.profit >= 0 ? 'text-emerald-600' : 'text-rose-600'}`}>{formatUSD(metrics.profit)}</div>
      </div>

      <div className="bg-white dark:bg-slate-800 p-4 rounded shadow">
        <div className="text-sm text-slate-500">Melhor / Pior</div>
        <div className="text-sm mt-1">{metrics.best ? `${metrics.best.ativo} ${formatUSD(metrics.best.resultado)}` : '—'}</div>
        <div className="text-sm mt-1">{metrics.worst ? `${metrics.worst.ativo} ${formatUSD(metrics.worst.resultado)}` : '—'}</div>
      </div>
    </div>
  )
}
