import Header from '../components/Header'
import ToolCard from '../components/ToolCard'
import Footer from '../components/Footer'

export default function Home() {
  return (
    <div className="container">
      <Header />

      <div className="grid">
        <ToolCard
          title="Monitor de Prop Firms"
          description="Acompanhe promoções, regras e avaliações das prop firms."
          status="Em breve"
        />

        <ToolCard
          title="Calculadora de Risco"
          description="Gerencie risco por trade de forma profissional."
          status="Ativo"
        />

        <ToolCard
          title="Diário de Trading"
          description="Registre, analise e evolua sua performance."
          status="Em breve"
        />

        <ToolCard
          title="Análise de Resultados"
          description="Métricas claras para decisões melhores."
          status="Em breve"
        />
      </div>

      <Footer />
    </div>
  )
}
