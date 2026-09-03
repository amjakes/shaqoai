import { React, useEffect, useState } from '../../utils/runtime.js';
import { Icon } from './icons.jsx';

const logoSrc = document.querySelector('link[rel="icon"]')?.href;
const links = ['Product', 'AI Workforce', 'Solutions', 'Integrations', 'Pricing'];

export function Navigation() {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 12);
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  return <>
    <header className={`site-header fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'py-3' : 'py-5'}`}>
      <div className={`mx-auto max-w-7xl px-5 flex items-center justify-between rounded-2xl transition-all duration-300 ${scrolled ? 'glass border border-[var(--line)] shadow-sm py-2.5 px-6' : 'px-5'}`}>
        <a href="#top" className="flex items-center gap-2.5 font-display font-bold text-lg tracking-tight"><img src={logoSrc} alt="ShaqoAI" className="w-8 h-8 rounded-lg object-cover shadow-sm" />ShaqoAI</a>
        <nav className="hidden lg:flex items-center gap-7 text-sm font-medium text-[var(--ink-soft)]">{links.map((link) => <a key={link} href={`#${link.toLowerCase().replace(/\s/g, '-')}`} className="hover:text-[var(--ink)] transition-colors">{link}</a>)}</nav>
        <div className="header-actions hidden lg:flex items-center shrink-0 gap-3"><span className="header-status hidden xl:inline-flex items-center gap-2 whitespace-nowrap"><span className="dot pulse-dot" /> Executive Agent Active</span><a href="/login?mode=login" className="text-sm font-medium px-4 py-2 text-[var(--ink-soft)] hover:text-[var(--ink)] transition-colors">Sign In</a><a href="/login?mode=signup" className="btn-primary text-sm font-semibold px-4 py-2.5 rounded-xl">Start Free Trial</a></div>
        <button 
