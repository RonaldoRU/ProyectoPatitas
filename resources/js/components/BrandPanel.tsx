export default function BrandPanel() {
    return (
        <section className="brand-panel" aria-label="Los Angelitos de Edgar">
            <img
                className="brand-panel__image"
                src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=1400&q=85"
                alt="Perro rescatado mirando con atención"
            />
            <div className="brand-panel__content">
                <span className="brand-panel__eyebrow">Refugio y cuidado animal</span>
                <h1>Los Angelitos de Edgar</h1>
                <p>Un lugar seguro. Una nueva oportunidad.</p>
                <span className="brand-panel__mark" aria-hidden="true">
                    PATITAS CRUCEÑAS <span>·</span> SANTA CRUZ, BOLIVIA
                </span>
            </div>
        </section>
    );
}