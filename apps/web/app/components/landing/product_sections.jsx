import { React } from '../../utils/runtime.js';
import { Icon } from './icons.jsx';

export function FeatureGrid() {
  co
    { number: '01', title: 'Connect', description: 'Connect the tools your business already uses.' },
    { number: '02', title: 'Configure', description: 'Define workflows, permissions, and business rules.' },
    { number: '03', title: 'Deploy', description: 'Assign specialized AI agents to your operations.' },
    { number: '04', title: 'Scale', description: 'Monitor performance and expand your AI workforce.' },
  ];
  return <section id="how-it-works" className="py-24 px-5"><div className="max-w-6xl mx-auto"><h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight text-center mb-14">How It Works</h2><div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">{steps.map((step, index) => <div key={step.number} className="js-reveal relative" style={{ animationDelay: `${index * .08}s` }}><div className="font-display text-4xl font-bold text-slate-200">{step.number}</div><div className="font-semibold mt-2">{step.title}</div><div className="text-sm text-[var(--ink-soft)] mt-1.5 leading-relaxed">{step.description}</div>{index < steps.length - 1 && <div className="hidden lg:block absolute top-4 -right-3 w-6 h-px bg-slate-200" />}</div>)}</div></div></section>;
}
