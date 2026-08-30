import { React } from '../../utils/runtime.js';

const logoSrc = document.querySelector('link[rel="icon"]')?.href;

export function FinalCTA() {
  return <section className="relative py-28 px-5 bg-gradient-to-br from-[#0B1220] to-[#13294B] overflow-hidden">
    <svg className="absolute inset-0 w-full h-full opacity-30" viewBox="0 0 800 300" preserveAspectRatio="none"><g stroke="#3B82F6" strokeWidth="1" fill="none"><path className="flow-line" d="M0,150 C200,50 400,250 800,120" /><path className="flow-line" d="M0,80 C250,220 500,20 800,200" style={{ animationDelay: '1s' }} /></g></svg>
    <div className="relative max-w-3xl mx-auto text-center text-white"><h2 className="js-reveal font-display text-3xl md:text-5xl font-bold tracking-tight leading-tight">Your Business Deserves a Workforce That Never Stops.</h2><p className="js-reveal text-slate-300 mt-6 max-w-xl mx-auto" style={{ animationDelay: '.05s' }}>Automate repetitive work, coordinate intelligent agents, and keep your team focused on the work that matters.</p><div className="js-reveal flex flex-wrap justify-center gap-4 mt-9" style={{ animationDelay: '.1s' }}><a href="/login?mode=signup" className="btn-primary font-semibold px-6 py-3.5 rounded-xl">Build Your AI Workforce →</a><a href="#" className="font-semibold px-6 py-3.5 rounded-xl border border-white/25 text-white hover:bg-white/10 transition-colors">Talk to ShaqoAI →</a></div></div>
  </section>;
}

export function Footer() {
  const columns = { Product: ['AI Workforce', 'Agents', 'Automations', 'Integrations', 'Pricing'], Solutions: ['Sales', 'Customer Support', 'Finance', 'Operations'], Company: ['About', 'Careers', 'Contact'], Resources: ['Documentation', 'Blog', 'Help Center'] };
  return <footer className="pt-16 pb-8 px-5 bg-white border-t border-[var(--line)]"><div className="max-w-6xl mx-auto grid sm:grid-cols-2 lg:grid-cols-5 gap-10"><div className="lg:col-span-1"><div className="flex items-center gap-2 font-display font-bold text-lg"><img src={logoSrc} alt="ShaqoAI" className="w-7 h-7 rounded-md object-cover" /> ShaqoAI</div><div className="text-sm text-[var(--ink-soft)] mt-2">AI Workforce. Reimagined.</div></div>{Object.entries(columns).map(([title, links]) => <div key={title}><div className="text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)] mb-4">{title}</div><ul className="flex flex-col gap-2.5">{links.map((link) => <li key={link}><a href="#" className="text-sm text-[var(--ink-soft)] hover:text-[var(--ink)] transition-colors">{link}</a></li>)}</ul></div>)}</div><div className="max-w-6xl mx-auto mt-14 pt-6 border-t border-[var(--line)] text-xs text-[var(--ink-soft)] flex flex-col sm:flex-row justify-between gap-3"><span>© 2026 ShaqoAI. All rights reserved.</span><span>Nairobi, Kenya · Built for African businesses</span></div></footer>;
}
