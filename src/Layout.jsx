export default function Layout({ children }) {
  return (
    <div className='min-h-screen bg-slate-900 text-slate-100'>
      <header className='p-4 border-b border-slate-700'>
        <h1 className='text-xl font-bold'>ACASATOOLS</h1>
        <p className='text-sm text-slate-400'>
          Mais do que trading, Ã© a sua casa
        </p>
      </header>

      <main className='p-6'>
        {children}
      </main>
    </div>
  )
}
