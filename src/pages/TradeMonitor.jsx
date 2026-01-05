import React from 'react'
import sampleTrades from '../data/sampleTrades.json'
import TradeMetrics from '../components/trades/TradeMetrics'
import TradeCharts from '../components/trades/TradeCharts'

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
