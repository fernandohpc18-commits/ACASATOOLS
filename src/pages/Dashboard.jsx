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
