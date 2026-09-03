import { React, useState } from '../../utils/runtime.js';
import { Icon } from './icons.jsx';

export function Pricing() {
  const [annual, setAnnual] = useState(true);
  const plans = [
    { name: 'Starter', 
      description: 'For small teams beginning automation.', 
      popular: false, 
      features: [
        '1 AI agent', 
        'Core integrations', 
        'Email support', 
        'Basic audit log'] },
    { name: 'Business', 
      description: 'For businesses deploying multiple AI agents.', 
      popular: true, 
      features: [
        'Up to 5 AI agents', 
        'All integrations', 
        'Priority support', 
        'Full audit trail', 
        'Human approval workflows'] },
    { name: 'Enterprise', 
      description: 'For organizations requiring advanced governance.', 
      popular: false, 
      features: [
        'Unlimited agents', 
        'Custom integrations', 
        'Dedicated support', 
        'Advanced governance', 
        'SLA & onboarding'] },
  ];  
  return 
  <section id="pricing" 
  className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
    <div className="max-w-6xl mx-auto">
      <div className="text-center mb-10">
        <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight">
          Simple, transparent pricing</h2>
          <p className="js-reveal text-[var(--ink-soft)] mt-4" 
          style={{ animationDelay: '.05s' }}>
            Pricing shown is illustrative. Contact sales for a plan tailored to your business.</p>
            <div className="js-reveal inline-flex items-center gap-3 mt-8 bg-white border border-[var(--line)] rounded-full p-1" 
            style={{ animationDelay: '.1s' }}>
              <button onClick={() => setAnnual(false)} 
              className={`px-4 py-2 text-sm font-semibold rounded-full transition-all 
              ${!annual ? 'bg-[var(--ink)] text-white' : 'text-[var(--ink-soft)]'}`}>Monthly</button><button onClick={() => setAnnual(true)} className={`px-4 py-2 text-sm font-semibold rounded-full transition-all ${annual ? 'bg-[var(--ink)] text-white' : 'text-[var(--ink-soft)]'}`}>Annual <span className="text-[var(--green)]">-20%</span></button></div></div><div className="grid md:grid-cols-3 gap-6">{plans.map((plan, index) => <div key={plan.name} className={`js-reveal card p-8 flex flex-col ${plan.popular ? 'border-2 border-[var(--blue)] shadow-xl relative md:-translate-y-3' : ''}`} style={{ animationDelay: `${index * .08}s` }}>{plan.popular && <span className="absolute -top-3 left-1/2 -translate-x-1/2 bg-[var(--blue)] text-white text-[10px] font-bold px-3 py-1 rounded-full tracking-wide">MOST POPULAR</span>}<div className="font-display font-bold text-lg">{plan.name}</div><div className="text-sm text-[var(--ink-soft)] mt-1.5 mb-6">{plan.description}</div><ul className="flex flex-col gap-2.5 mb-8 flex-1">{plan.features.map((feature) => <li key={feature} className="text-sm flex items-center gap-2"><Icon.check className="w-3.5 h-3.5 text-[var(--green)] shrink-0" />{feature}</li>)}</ul><a href="/login?mode=signup" className={`text-center font-semibold py-3 rounded-xl text-sm ${plan.popular ? 'btn-primary' : 'btn-ghost'}`}>{plan.name === 'Enterprise' ? 'Contact Sales' : 'Start Free Trial'}</a></div>)}</div></div></section>;
}