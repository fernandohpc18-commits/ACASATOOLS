export default function ToolCard({ title, description, status }) {
  return (
    <div
      style={{
        background: '#111827',
        padding: '1.5rem',
        borderRadius: '16px',
        border: '1px solid #1f2937'
      }}
    >
      <h3 style={{ marginBottom: '0.5rem' }}>{title}</h3>
      <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
        {description}
      </p>

      <span
        style={{
          display: 'inline-block',
          marginTop: '1rem',
          fontSize: '0.75rem',
          padding: '0.3rem 0.6rem',
          borderRadius: '999px',
          background: status === 'Ativo' ? '#22c55e' : '#374151',
          color: '#020617'
        }}
      >
        {status}
      </span>
    </div>
  )
}
