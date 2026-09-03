import { React, useState, useEffect, useRef, useMemo, useCallback } from '../../utils/runtime.js';
import { Navigation } from './navigation.jsx';
import { FinalCTA, Footer } from './site_sections.jsx';
import { FeatureGrid, HowItWorks } from './product_sections.jsx';
import { useCountUp, useReveal } from './hooks.js';
import { activityEvents as ACTIVITY_EVENTS, agentTabs as AGENT_TABS, agents as AGENTS, integrations as INTEGRATIONS } from './agent_data.js';
import { Pricing } from './pricing.jsx';
import { WhatsAppLauncher } from './whatsapp_launcher.jsx';
const LOGO_SRC = document.querySelector('link[rel="icon"]').href;

function legacyUseReveal(){
  useEffect(()=>{
    const els = document.querySelectorAll('.js-reveal');
    const io = new IntersectionObserver((entries)=>{
      entries.forEach(e=>{
        if(e.isIntersecting){
          e.target.classList.add('reveal');
          io.unobserve(e.target);
        }
      });
    }, {threshold:0.15});
    els.forEach(el=>io.observe(el));
    return ()=>io.disconnect();
  });
}

function legacyUseCountUp(target, duration=1400, trigger=true){
  const [val, setVal] = useState(0);
  const ref = useRef(null);
  useEffect(()=>{
    if(!trigger) return;
    let raf, start;
    const step = (t)=>{
      if(!start) start = t;
      const p = Math.min(1, (t-start)/duration);
      const eased = 1 - Math.pow(1-p, 3);
      setVal(target*eased);
      if(p<1) raf = requestAnimationFrame(step);
    };
    raf = requestAnimationFrame(step);
    return ()=>cancelAnimationFrame(raf);
  }, [target, trigger, duration]);
  return val;
}


/* ---------------- Icons (inline SVG, no deps) ---------------- */
const Icon = {
  bolt: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><path d="M13 2 3 14h8l-1 8 10-12h-8l1-8Z" strokeLinejoin="round" strokeLinecap="round"/></svg>),
  users: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><circle cx="9" cy="8" r="3.2"/><path d="M2.5 20c1-3.6 3.6-5.5 6.5-5.5s5.5 1.9 6.5 5.5" strokeLinecap="round"/><circle cx="17.5" cy="9" r="2.6"/><path d="M15.8 14.8c2.6.2 4.6 2 5.4 5.2" strokeLinecap="round"/></svg>),
  shield: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><path d="M12 3l7 3v6c0 4.6-3 8.2-7 9-4-.8-7-4.4-7-9V6l7-3Z" strokeLinejoin="round"/><path d="m9 12 2 2 4-4" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  globe: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.7 2.6 4 5.7 4 9s-1.3 6.4-4 9c-2.7-2.6-4-5.7-4-9s1.3-6.4 4-9Z"/></svg>),
  check: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" {...p}><path d="m4 12 5.5 5.5L20 7" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  arrow: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" {...p}><path d="M5 12h14M13 6l6 6-6 6" strokeLinecap="round" strokeLinejoin="round"/></svg>),
  menu: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><path d="M4 7h16M4 12h16M4 17h16" strokeLinecap="round"/></svg>),
  close: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><path d="M6 6l12 12M18 6 6 18" strokeLinecap="round"/></svg>),
  play: (p)=>(<svg viewBox="0 0 24 24" fill="currentColor" {...p}><path d="M8 5.5v13l11-6.5-11-6.5Z"/></svg>),
  wallet: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><rect x="3" y="6" width="18" height="13" rx="2.5"/><path d="M3 10h18" /><circle cx="16" cy="14" r="1.3" fill="currentColor" stroke="none"/></svg>),
  chat: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><path d="M4 5.5h16v11H9l-5 4v-4H4v-11Z" strokeLinejoin="round"/></svg>),
  calendar: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><rect x="3.5" y="5" width="17" height="15.5" rx="2.5"/><path d="M8 3v4M16 3v4M3.5 10h17" strokeLinecap="round"/></svg>),
  chart: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><path d="M4 20V10M12 20V4M20 20v-7" strokeLinecap="round"/></svg>),
  lock: (p)=>(<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...p}><rect x="4.5" y="10.5" width="15" height="10" rx="2.4"/><path d="M8 10.5V7.5a4 4 0 0 1 8 0v3" strokeLinecap="round"/></svg>),
};

/* ---------------- Data ---------------- */
const LEGACY_AGENTS = [
  { key:'exec', name:'Executive Agent', status:'Active', work:'6 tasks queued', color:'#1E4FA0', icon:Icon.calendar, angle:-90 },
  { key:'sales', name:'Sales Agent', status:'Working', work:'3 qualified leads', color:'#2E7BD6', icon:Icon.users, angle:-18 },
  { key:'finance', name:'Finance Agent', status:'Processing', work:'12 transactions', color:'#14B8A6', icon:Icon.wallet, angle:54 },
  { key:'support', name:'Support Agent', status:'Active', work:'7 conversations', color:'#F59E0B', icon:Icon.chat, angle:126 },
  { key:'ops', name:'Operations Agent', status:'Idle', work:'0 blocked tasks', color:'#64748B', icon:Icon.chart, angle:198 },
];


const LEGACY_ACTIVITY_EVENTS = [
  {t:'09:42', who:'Sales Agent', what:'Lead captured from WhatsApp', color:'#2E7BD6'},
  {t:'09:43', who:'Support Agent', what:'Customer request classified', color:'#F59E0B'},
  {t:'09:44', who:'Finance Agent', what:'M-Pesa payment matched to invoice', color:'#14B8A6'},
  {t:'09:45', who:'Executive Agent', what:'Calendar updated for 3pm review', color:'#1E4FA0'},
  {t:'09:47', who:'Sales Agent', what:'Follow-up scheduled in HubSpot', color:'#2E7BD6'},
  {t:'09:49', who:'Finance Agent', what:'Payment queued for approval', color:'#14B8A6'},
];

const LEGACY_AGENT_TABS = {
  sales: {
    label:'Sales Agent',
    steps:['Lead Capture — WhatsApp','Qualification — AI Analysis','CRM Sync — HubSpot','Follow-up — Scheduled'],
    integrations:'WhatsApp → ShaqoAI → HubSpot',
  },
  support: {
    label:'Support Agent',
    steps:['Customer Message','Intent Detection','Knowledge Search','Response Sent','Escalation if Needed'],
    integrations:'WhatsApp / Email → ShaqoAI → Helpdesk',
  },
  finance: {
    label:'Finance Agent',
    steps:['M-Pesa Transaction','Transaction Matching','Invoice Verification','Human Approval','Receipt Issued'],
    integrations:'Daraja API → ShaqoAI → Accounting',
  },
  executive: {
    label:'Executive Agent',
    steps:['Email Received','Prioritization','Task Creation','Calendar Update','Team Follow-up'],
    integrations:'Gmail / Outlook → ShaqoAI → Calendar',
  }
};

const LEGACY_INTEGRATIONS = ['M-Pesa','WhatsApp','Gmail','Google Calendar','Microsoft Outlook','HubSpot','Shopify','PostgreSQL'];

const DEPT_COLORS = {
  'Sales & Business Development':'#1E4FA0',
  'Marketing & Content':'#2E7BD6',
  'Operations & Projects':'#14B8A6',
  'People & Finance':'#F59E0B',
  'Customer & Executive Support':'#0EA5E9',
  'Education':'#7C3AED',
  'Engineering & Design':'#DB2777',
  'Legal & Compliance':'#475569',
  'Healthcare Administration':'#059669',
  'Commerce & Data':'#2563EB',
  'Career & Lifestyle':'#D97706',
};

const AI_EMPLOYEES = [
  { emoji:'💼', name:'Amara', role:'AI Business Development Manager', dept:'Sales & Business Development', skills:['Prospecting','Company Research','Decision-Maker ID','Outreach'], can:'Finds prospects, researches companies, identifies decision-makers, generates leads, and manages follow-ups.' },
  { emoji:'📈', name:'Sarah', role:'AI Sales Representative', dept:'Sales & Business Development', skills:['Lead Qualification','Quotations','Follow-up','Closing'], can:'Qualifies leads, answers product questions, prepares quotations, and helps close sales.' },
  { emoji:'📱', name:'Jordan', role:'AI Social Media Manager', dept:'Marketing & Content', skills:['Content Calendar','Copywriting','Campaigns','Analytics'], can:'Plans content, writes posts, builds content calendars, and analyzes social performance.' },
  { emoji:'✍️', name:'Maya', role:'AI Content Writer', dept:'Marketing & Content', skills:['Blogging','Newsletters','Ad Copy','Proposals'], can:'Writes blogs, articles, website content, newsletters, and marketing copy.' },
  { emoji:'🔎', name:'Elena', role:'AI Research Analyst', dept:'Marketing & Content', skills:['Market Research','Competitor Analysis','Reporting'], can:'Researches markets, competitors, and industries, and produces structured reports.' },
  { emoji:'📋', name:'Farah', role:'AI Tender & Proposal Specialist', dept:'Sales & Business Development', skills:['RFP Analysis','Compliance Matrix','Proposal Drafting'], can:'Finds tenders, analyzes RFPs, builds compliance matrices, and drafts proposals on deadline.' },
  { emoji:'👥', name:'Deka', role:'AI HR Manager', dept:'People & Finance', skills:['Job Descriptions','CV Screening','Interview Prep','Onboarding'], can:'Creates job descriptions, screens and ranks applicants, and supports onboarding.' },
  { emoji:'💰', name:'Kevin', role:'AI Finance Assistant', dept:'People & Finance', skills:['Expense Tracking','Invoicing','Reporting'], can:'Tracks expenses, prepares invoices, organizes financial data, and generates basic reports.' },
  { emoji:'🎧', name:'Zara', role:'AI Customer Support Agent', dept:'Customer & Executive Support', skills:['Troubleshooting','Ticketing','Escalation'], can:'Answers customers, troubleshoots common problems, and manages support tickets.' },
  { emoji:'🗓️', name:'Grace', role:'AI Executive Assistant', dept:'Customer & Executive Support', skills:['Scheduling','Inbox Triage','Briefings'], can:'Manages schedules, meetings, reminders, emails, tasks, and daily briefings.' },
  { emoji:'👨‍🏫', name:'Nadia', role:'AI Teacher / Tutor', dept:'Education', skills:['Curriculum Design','Lesson Delivery','Homework & Grading','Progress Tracking'], can:'Builds a personalized curriculum, teaches step-by-step, sets homework, and adapts difficulty automatically.' },
  { emoji:'🗣️', name:'Layla', role:'AI Language Teacher', dept:'Education', skills:['Conversation Practice','Grammar','Pronunciation'], can:'Teaches languages through conversation, vocabulary, grammar, and pronunciation exercises.' },
  { emoji:'💻', name:'Marcus', role:'AI Software Developer', dept:'Engineering & Design', skills:['Coding','Debugging','APIs'], can:'Builds and debugs software, writes code, and helps design and develop applications.' },
  { emoji:'🎨', name:'Leo', role:'AI Graphic Designer', dept:'Engineering & Design', skills:['Brand Concepts','Social Visuals','Presentations'], can:'Creates brand concepts, marketing visuals, social-media designs, and presentations.' },
  { emoji:'⚖️', name:'Victor', role:'AI Legal Assistant', dept:'Legal & Compliance', skills:['Contract Review','Clause Identification','Legal Research'], can:'Researches laws, summarizes contracts, and organizes legal documents.', disclaimer:'Not a substitute for a licensed lawyer.' },
  { emoji:'🏥', name:'Naima', role:'AI Medical Administrative Assistant', dept:'Healthcare Administration', skills:['Appointments','Admin Documents','General Info'], can:'Organizes appointments, summarizes non-diagnostic information, and prepares administrative documents.', disclaimer:'Directs medical decisions to qualified professionals.' },
  { emoji:'🛒', name:'Priya', role:'AI E-commerce Manager', dept:'Commerce & Data', skills:['Listings','Inventory','Promotions'], can:'Manages product listings, customer questions, inventory info, and sales analysis.' },
  { emoji:'🧑‍💼', name:'Daniel', role:'AI Project Manager', dept:'Operations & Projects', skills:['Task Breakdown','Deadlines','Progress Reports'], can:'Breaks projects into tasks, monitors deadlines, and flags potential delays.' },
  { emoji:'📊', name:'Chen', role:'AI Data Analyst', dept:'Commerce & Data', skills:['Spreadsheets','Trend Analysis','Insights'], can:'Analyzes spreadsheets and datasets, identifies trends, and explains insights in plain language.' },
  { emoji:'📢', name:'Aisha', role:'AI Marketing Manager', dept:'Marketing & Content', skills:['Strategy','Personas','Budgets'], can:'Develops marketing strategies, customer personas, campaigns, and performance reports.' },
  { emoji:'🧑‍💻', name:'Ryan', role:'AI IT Support Specialist', dept:'Engineering & Design', skills:['Troubleshooting','Documentation','Software & Hardware'], can:'Diagnoses common technical problems and guides users through fixes.' },
  { emoji:'📄', name:'Fatima', role:'AI Resume & Career Coach', dept:'Career & Lifestyle', skills:['CV Writing','Cover Letters','Interview Prep'], can:'Improves CVs, writes cover letters, and prepares candidates for interviews.' },
  { emoji:'🌍', name:'Noah', role:'AI Travel Planner', dept:'Career & Lifestyle', skills:['Itineraries','Comparisons','Scheduling'], can:'Researches destinations, builds itineraries, and compares travel options.' },
  { emoji:'🏢', name:'Halima', role:'AI Operations Manager', dept:'Operations & Projects', skills:['SOPs','Workflows','Efficiency'], can:'Creates SOPs, organizes workflows, and identifies ways to improve efficiency.' },
  { emoji:'🧠', name:'Sam', role:'AI Personal Productivity Coach', dept:'Career & Lifestyle', skills:['Goal Setting','Prioritization','Accountability'], can:'Helps set goals, prioritize tasks, build routines, and track progress.' },
];


/* ---------------- Nav ---------------- */
function LegacyNav(){
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  useEffect(()=>{
    const onScroll = ()=> setScrolled(window.scrollY > 12);
    window.addEventListener('scroll', onScroll);
    return ()=>window.removeEventListener('scroll', onScroll);
  },[]);
  const links = ['Product','AI Workforce','Solutions','Integrations','Pricing'];
  return (
    <>
    <header className={`site-header fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${scrolled ? 'py-3' : 'py-5'}`}>
      <div className={`mx-auto max-w-7xl px-5 flex items-center justify-between rounded-2xl transition-all duration-300 ${scrolled ? 'glass border border-[var(--line)] shadow-sm py-2.5 px-6' : 'px-5'}`}>
        <a href="#top" className="flex items-center gap-2.5 font-display font-bold text-lg tracking-tight">
          <img src={LOGO_SRC} alt="ShaqoAI" className="w-8 h-8 rounded-lg object-cover shadow-sm"/>
          ShaqoAI
        </a>
        <nav className="hidden lg:flex items-center gap-7 text-sm font-medium text-[var(--ink-soft)]">
          {links.map(l=>(<a key={l} href={'#'+l.toLowerCase().replace(/\s/g,'-')} className="hover:text-[var(--ink)] transition-colors">{l}</a>))}
        </nav>
        <div className="header-actions hidden lg:flex items-center shrink-0 gap-3">
          <span className="header-status hidden xl:inline-flex items-center gap-2 whitespace-nowrap">
            <span className="dot pulse-dot"/> Executive Agent Active
          </span>
          <a href="/login?mode=login" className="text-sm font-medium px-4 py-2 text-[var(--ink-soft)] hover:text-[var(--ink)] transition-colors">Sign In</a>
          <a href="/login?mode=signup" className="btn-primary text-sm font-semibold px-4 py-2.5 rounded-xl">Start Free Trial</a>
        </div>
        <button className="md:hidden p-2 -mr-2" onClick={()=>setOpen(true)} aria-label="Open menu"><Icon.menu className="w-6 h-6"/></button>
      </div>
    </header>
    <div className={`fixed inset-0 z-[60] md:hidden transition-all duration-300 ${open ? 'pointer-events-auto' : 'pointer-events-none'}`}>
      <div className={`absolute inset-0 bg-black/30 transition-opacity duration-300 ${open?'opacity-100':'opacity-0'}`} onClick={()=>setOpen(false)}/>
      <div className={`mobile-drawer absolute top-0 right-0 h-full w-[78%] max-w-xs bg-white shadow-2xl transition-transform duration-300 ${open? 'translate-x-0':'translate-x-full'} p-6 flex flex-col`}>
        <div className="flex justify-between items-center mb-8">
          <span className="flex items-center gap-2 font-display font-bold"><img src={LOGO_SRC} alt="ShaqoAI" className="w-7 h-7 rounded-lg object-cover"/>ShaqoAI</span>
          <button onClick={()=>setOpen(false)}><Icon.close className="w-6 h-6"/></button>
        </div>
        <div className="flex flex-col gap-5 text-base font-medium">
          {links.map(l=>(<a key={l} href={'#'+l.toLowerCase().replace(/\s/g,'-')} onClick={()=>setOpen(false)}>{l}</a>))}
        </div>
        <div className="mt-auto flex flex-col gap-3">
          <a href="/login?mode=login" className="btn-ghost text-center py-2.5 rounded-xl font-medium">Sign In</a>
          <a href="/login?mode=signup" onClick={()=>setOpen(false)} className="btn-primary text-center py-2.5 rounded-xl font-semibold">Start Free Trial</a>
        </div>
      </div>
    </div>
    </>
  );
}


/* ---------------- Deployment Center (agent network) ---------------- */
function DeploymentCenter(){
  const [activeAgent, setActiveAgent] = useState(null);
  const agents = [
    {key:'exec', label:'Executive Agent', detail:'Orchestrating decisions', icon:Icon.users, position:'hero-agent--executive', color:'#4ade80'},
    {key:'manager', label:'AI Manager Agent', detail:'Overseeing 5 workflows', icon:Icon.chart, position:'hero-agent--manager', color:'#a78bfa'},
    {key:'data', label:'Data Scientist Agent', detail:'Processing new datasets', icon:Icon.chart, position:'hero-agent--data', color:'#22d3ee'},
    {key:'support', label:'Support Agent', detail:'17 tickets · 7 conversations', icon:Icon.chat, position:'hero-agent--support', color:'#38bdf8'},
    {key:'ops', label:'Operations Agent', detail:'0 blocked tasks', icon:Icon.bolt, position:'hero-agent--operations', color:'#2dd4bf'},
    {key:'finance', label:'Finance Agent', detail:'Processing · 12 transactions', icon:Icon.wallet, position:'hero-agent--finance', color:'#fbbf24'},
  ];
  const activity = [
    ['05:44','Finance Agent','M-Pesa payment matched to invoice','#2dd4bf'],
    ['09:45','Executive Agent','Calendar updated for 3pm review','#a78bfa'],
    ['09:47','Sales Agent','Follow-up scheduled in HubSpot','#38bdf8'],
    ['08:49','Finance Agent','Payment queued for approval','#fbbf24'],
  ];
  return (
    <div className="hero-network select-none">
      <div className="hero-network__mesh" aria-hidden="true"/>
      <svg viewBox="0 0 760 600" className="hero-network__vectors" aria-hidden="true">
        <defs>
          <linearGradient id="heroLineGrad" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stopColor="#22d3ee" stopOpacity="0.14"/>
            <stop offset="55%" stopColor="#67e8f9" stopOpacity="0.85"/>
            <stop offset="100%" stopColor="#a78bfa" stopOpacity="0.3"/>
          </linearGradient>
          <radialGradient id="heroGlow"><stop stopColor="#22d3ee" stopOpacity=".3"/><stop offset="1" stopColor="#22d3ee" stopOpacity="0"/></radialGradient>
        </defs>
        <circle cx="398" cy="304" r="220" fill="url(#heroGlow)"/>
        {['M398 304 C390 190 404 136 420 92','M398 304 C490 202 590 138 670 108','M398 304 C520 280 638 300 690 350','M398 304 C480 386 580 438 670 476','M398 304 C325 420 242 480 142 500','M398 304 C266 302 150 272 90 230','M398 304 C278 210 200 190 130 168'].map((path,i)=>(
          <path key={path} d={path} fill="none" stroke="url(#heroLineGrad)" strokeWidth="1.35" className="flow-line" style={{animationDelay:`${i*.5}s`}}/>
        ))}
        {[['398','304'],['420','92'],['670','108'],['690','350'],['670','476'],['142','500'],['90','230'],['130','168']].map(([cx,cy],i)=><circle key={i} cx={cx} cy={cy} r={i ? '3' : '5'} fill={i ? '#67e8f9' : '#fff'} />)}
      </svg>
      <div className="hero-core float">
        <img src={LOGO_SRC} alt="ShaqoAI" className="hero-core__logo"/>
      </div>
      {agents.map((agent,i)=>{
        const AgentIcon = agent.icon;
        return (
          <button key={agent.key} onMouseEnter={()=>setActiveAgent(agent.key)} onMouseLeave={()=>setActiveAgent(null)} onClick={()=>setActiveAgent(activeAgent===agent.key?null:agent.key)}
            style={{animationDelay:`${i*0.4}s`}}
            className={`hero-agent ${agent.position} float-slow ${activeAgent===agent.key ? 'hero-agent--active' : ''}`}>
            <span className="hero-agent__icon" style={{background:agent.color+'1f', color:agent.color}}><AgentIcon/></span>
            <span className="hero-agent__copy"><b>{agent.label}</b><small>{agent.detail}</small></span>
            {agent.key==='finance' && <span className="hero-agent__live"/>}
          </button>
        );
      })}
      <div className="hero-workflow">
        <div className="hero-panel__title">Sales Agent Workflow</div>
        {[['Lead Capture','WhatsApp · 09:42'],['Qualification','AI Analysis · 09:43'],['CRM Sync','HubSpot · 09:44']].map(([title,detail],i)=>(
          <div className="hero-step" key={title}><span className={i===1?'hero-step__dot hero-step__dot--active':'hero-step__dot'}/><div><b>{title}</b><small>{detail}</small></div></div>
        ))}
      </div>
      <div className="hero-activity">
        <div className="hero-panel__title">Autonomous Activity</div>
        {activity.map(([time,agent,event,color])=><div className="hero-activity__item" key={time+agent}><i style={{background:color}}/><div><small>{time} · {agent}</small><b>{event}</b></div></div>)}
      </div>
      <div className="hero-hub"><span className="hero-hub__label">Agent Hub</span><span className="hero-hub__core"/><span className="hero-hub__node hero-hub__node--a">Security Agent</span><span className="hero-hub__node hero-hub__node--b">QA Agent</span><span className="hero-hub__node hero-hub__node--c">Market Analyst</span></div>
    </div>
  );
}


/* ---------------- Floating Workflow Panel ---------------- */
function WorkflowPanel(){
  const steps = [
    {t:'Lead Capture', d:'WhatsApp', time:'09:42'},
    {t:'Qualification', d:'AI Analysis', time:'09:43'},
    {t:'CRM Sync', d:'HubSpot', time:'09:44'},
    {t:'Follow-up', d:'Scheduled', time:'09:46'},
  ];
  const [active, setActive] = useState(0);
  useEffect(()=>{
              <div className="text-xs font-semibold">{s.t}</div>
              <div className="text-[11px] text-[var(--ink-soft)]">{s.d} · {s.time}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}


/* ---------------- Activity Feed ---------------- */
function ActivityFeed(){
  const [items, setItems] = useState(ACTIVITY_EVENTS.slice(0,3));
  const idx = useRef(3);
  useEffect(()=>{
    const iv = setInterval(()=>{
      setItems(prev=>{
        const next = [...prev, ACTIVITY_EVENTS[idx.current % ACTIVITY_EVENTS.length]];
        idx.current++;
        return next.slice(-4);
      });
    }, 2200);
    return ()=>clearInterval(iv);
  },[]);
  return (
    <div className="hero-sidecard card p-5 w-72 shadow-lg">
      <div className="hero-sidecard__title">Autonomous Activity</div>
      <div className="flex flex-col gap-3 h-[168px] overflow-hidden scrollbar-thin">
        {items.map((e,i)=>(
          <div key={e.who+i+e.t} className="flex items-start gap-2.5" style={{animation:'fadeUp .5s ease both'}}>
            <span className="dot mt-1.5" style={{background:e.color}}/>
            <div>
              <div className="text-[11px] text-[var(--ink-soft)]">{e.t} · <span className="font-semibold text-[var(--ink)]">{e.who}</span></div>
              <div className="text-xs text-[var(--ink)]">{e.what}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}


/* ---------------- Hero ---------------- */
function Hero(){
  return (
    <section id="top" className="relative grain-bg pt-36 pb-24 md:pt-44 md:pb-32 px-5">
      <div className="hero-layout max-w-7xl mx-auto grid lg:grid-cols-12 gap-10 xl:gap-14 items-center">
        <div className="hero-copy">
          <div className="js-reveal inline-flex items-center gap-2 text-[11px] font-semibold tracking-wider uppercase text-[var(--blue)] bg-[var(--bg-mist)] border border-blue-100 px-3 py-1.5 rounded-full">
            <span className="dot pulse-dot" style={{background:'#1E4FA0'}}/> AI-Powered Operations
          </div>
          <h1 className="js-reveal font-display text-[2.6rem] leading-[1.05] sm:text-5xl md:text-6xl font-bold tracking-tight mt-5" style={{animationDelay:'.05s'}}>
            Deploy Your <span className="grad-text">Autonomous AI Workforce</span>
          </h1>
          <p className="js-reveal text-lg text-[var(--ink-soft)] mt-6 max-w-lg leading-relaxed" style={{animationDelay:'.1s'}}>
            ShaqoAI gives businesses intelligent AI agents that automate workflows, coordinate operations, and help teams get more done — with humans always in control when it matters.
          </p>
          <div className="js-reveal flex flex-wrap items-center gap-4 mt-8" style={{animationDelay:'.15s'}}>
            <a href="/login?mode=signup" className="btn-primary font-semibold px-6 py-3.5 rounded-xl inline-flex items-center gap-2">
              Build Your AI Workforce <Icon.arrow className="w-4 h-4"/>
            </a>
            <a href="#how-it-works" className="btn-ghost font-semibold px-6 py-3.5 rounded-xl inline-flex items-center gap-2">
              <Icon.play className="w-4 h-4"/> Watch How It Works
            </a>
          </div>
          <div className="js-reveal flex items-center gap-6 mt-10 text-xs text-[var(--ink-soft)]" style={{animationDelay:'.2s'}}>
            <span className="flex items-center gap-1.5"><Icon.check className="w-3.5 h-3.5 text-[var(--green)]"/> No credit card required</span>
            <span className="flex items-center gap-1.5"><Icon.check className="w-3.5 h-3.5 text-[var(--green)]"/> Human approval built in</span>
          </div>
        </div>

        <div className="hero-visual">
          <div className="hero-visual__label">Deployment Center</div>
          <DeploymentCenter/>
        </div>
      </div>
    </section>
  );
}

/* ---------------- Impact Metrics ---------------- */
function ImpactMetrics(){
  const [seen, setSeen] = useState(false);
  const ref = useRef(null);
  useEffect(()=>{
    const io = new IntersectionObserver(([e])=>{ if(e.isIntersecting) setSeen(true); }, {threshold:.4});
    if(ref.current) io.observe(ref.current);
    return ()=>io.disconnect();
  },[]);
  const a = useCountUp(90, 1200, seen);
  const b = useCountUp(40, 1200, seen);
  const metrics = [
    { val: Math.round(a)+'%+', label:'Potential repetitive-work automation'},
    { val: Math.round(b)+'%+', label:'Potential operational overhead reduction'},
    { val:'24/7', label:'AI workforce availability'},
    { val:'M-Pesa', label:'Local payment workflow support'},
  ];
  return (
    <section ref={ref} className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
      <div className="max-w-6xl mx-auto text-center">
        <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight">Built for Kenya. Ready for the world.</h2>
        <p className="js-reveal text-[var(--ink-soft)] max-w-xl mx-auto mt-4" style={{animationDelay:'.05s'}}>ShaqoAI combines modern AI automation with the tools and workflows businesses already use across East Africa.</p>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mt-14">
          {metrics.map((m,i)=>(
            <div key={i} className="js-reveal card py-8 px-4" style={{animationDelay:`${0.1+i*0.07}s`}}>
              <div className="font-display num-tick text-3xl md:text-4xl font-bold grad-text">{m.val}</div>
              <div className="text-xs text-[var(--ink-soft)] mt-2 leading-snug">{m.label}</div>
            </div>
          ))}
        </div>
        <div className="text-[11px] text-[var(--ink-soft)] mt-6 uppercase tracking-wide">Illustrative automation potential — not independently verified customer results</div>
      </div>
    </section>
  );
}


/* ---------------- Agent Showcase ---------------- */
function AgentShowcase(){
  const [tab, setTab] = useState('sales');
  const data = AGENT_TABS[tab];
  return (
    <section id="solutions" className="py-24 px-5">
      <div className="max-w-5xl mx-auto text-center">
        <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight">Meet Your AI Workforce</h2>
        <p className="js-reveal text-[var(--ink-soft)] mt-4" style={{animationDelay:'.05s'}}>Specialized agents, each built for a specific part of your business.</p>

        <div className="js-reveal inline-flex flex-wrap justify-center gap-1 mt-10 p-1 bg-[var(--bg-soft)] border border-[var(--line)] rounded-2xl" style={{animationDelay:'.1s'}}>
          {Object.entries(AGENT_TABS).map(([k,v])=>(
            <button key={k} onClick={()=>setTab(k)}
              className={`px-4 py-2.5 text-sm font-semibold rounded-xl transition-all duration-200 ${tab===k ? 'bg-white shadow-sm text-[var(--blue)]' : 'text-[var(--ink-soft)] hover:text-[var(--ink)]'}`}>
              {v.label}
            </button>
          ))}
        </div>

        <div className="card mt-8 p-8 md:p-12 text-left">
          <div className="text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)] mb-6">{data.integrations}</div>
          <div className="flex flex-col md:flex-row md:items-center gap-4 md:gap-0">
            {data.steps.map((s,i)=>(
              <React.Fragment key={s}>
                <div className="flex-1 card px-4 py-4 hover:glow-active transition-all duration-200">
                  <div className="text-[11px] text-[var(--ink-soft)] mb-1">Step {i+1}</div>
                  <div className="text-sm font-semibold">{s}</div>
                </div>
                {i<data.steps.length-1 && (
                  <div className="hidden md:flex items-center justify-center px-2 text-[var(--blue)]"><Icon.arrow className="w-4 h-4"/></div>
                )}
              </React.Fragment>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}


/* ---------------- AI Employee Directory (25 agents) ---------------- */
function AgentDirectory(){
  const depts = useMemo(()=>['All', ...Array.from(new Set(AI_EMPLOYEES.map(e=>e.dept)))], []);
  const [filter, setFilter] = useState('All');
  const [hired, setHired] = useState(()=>new Set());

  const toggleHire = (name)=>{
    setHired(prev=>{
      const next = new Set(prev);
      next.has(name) ? next.delete(name) : next.add(name);
      return next;
    });
  };

  const visible = filter==='All' ? AI_EMPLOYEES : AI_EMPLOYEES.filter(e=>e.dept===filter);

  return (
    <section id="ai-workforce" className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-4">
          <div className="js-reveal inline-flex items-center gap-2 text-[11px] font-semibold tracking-wider uppercase text-[var(--blue)] bg-[var(--bg-mist)] border border-blue-100 px-3 py-1.5 rounded-full">
            25 AI Employees Ready to Hire
          </div>
          <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight mt-5" style={{animationDelay:'.05s'}}>Build Your Company With AI Employees</h2>
          <p className="js-reveal text-[var(--ink-soft)] max-w-2xl mx-auto mt-4" style={{animationDelay:'.1s'}}>
            Every ShaqoAI employee has a name, a role, and a set of skills — not just a generic chatbot. Hire the ones your business needs and assemble your own AI workforce.
          </p>
        </div>

        <div className="js-reveal flex flex-wrap justify-center gap-2 mt-9 mb-10" style={{animationDelay:'.15s'}}>
          {depts.map(d=>(
            <button key={d} onClick={()=>setFilter(d)}
              className={`px-3.5 py-2 text-xs font-semibold rounded-full border transition-all duration-200 ${filter===d ? 'bg-[var(--ink)] text-white border-[var(--ink)]' : 'bg-white text-[var(--ink-soft)] border-[var(--line)] hover:border-slate-300'}`}>
              {d}
            </button>
          ))}
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {visible.map((e,i)=>{
            const color = DEPT_COLORS[e.dept] || 'var(--blue)';
            const isHired = hired.has(e.name);
            return (
              <div key={e.name+e.role} className="js-reveal card p-6 flex flex-col hover:-translate-y-1 hover:shadow-lg transition-all duration-300" style={{animationDelay:`${(i%6)*0.06}s`}}>
                <div className="flex items-start gap-3 mb-4">
                  <span className="w-11 h-11 rounded-xl flex items-center justify-center text-xl shrink-0" style={{background:color+'1a'}}>{e.emoji}</span>
                  <div className="min-w-0">
                    <div className="font-semibold text-sm truncate">{e.name} <span className="text-[var(--ink-soft)] font-normal">— {e.role}</span></div>
                    <div className="text-[10px] font-semibold uppercase tracking-wide mt-1" style={{color}}>{e.dept}</div>
                  </div>
                </div>
                <p className="text-[13px] text-[var(--ink-soft)] leading-relaxed mb-4">{e.can}</p>
                <div className="flex flex-wrap gap-1.5 mb-5">
                  {e.skills.map(s=>(
                    <span key={s} className="text-[10px] font-medium px-2 py-1 rounded-md bg-[var(--bg-soft)] border border-[var(--line)] text-[var(--ink-soft)]">{s}</span>
                  ))}
                </div>
                {e.disclaimer && (
                  <div className="text-[10.5px] text-amber-700 bg-amber-50 border border-amber-100 rounded-lg px-2.5 py-2 mb-4 leading-snug">{e.disclaimer}</div>
                )}
                <div className="mt-auto flex items-center justify-between pt-4 border-t border-[var(--line)]">
                  <span className="text-[11px] text-[var(--ink-soft)] flex items-center gap-1.5"><span className="dot pulse-dot" style={{background:'#22C55E'}}/> Works 24/7</span>
                  <button onClick={()=>toggleHire(e.name)}
                    className={`text-xs font-semibold px-4 py-2 rounded-lg transition-all duration-200 ${isHired ? 'bg-green-50 text-green-700 border border-green-200' : 'btn-primary'}`}>
                    {isHired ? '✓ Hired' : `Hire ${e.name}`}
                  </button>
                </div>
              </div>
            );
          })}
        </div>

        {hired.size>0 && (
          <div className="js-reveal mt-10 text-center text-sm text-[var(--ink-soft)]">
            You've hired <span className="font-semibold text-[var(--ink)]">{hired.size}</span> AI employee{hired.size>1?'s':''} — start building your workflows in the dashboard once you're live.
          </div>
        )}
      </div>
    </section>
  );
}
function RoiCalculator(){
  const [industry, setIndustry] = useState('Professional Services');
  const [employees, setEmployees] = useState(25);
  const [hours, setHours] = useState(15);
  const [rate, setRate] = useState(700);

  const weeklySavedHours = employees * hours * 0.6;
  const monthlyValue = weeklySavedHours * 4.33 * rate;
  const annualValue = monthlyValue * 12;

  const animAnnual = useCountUp(annualValue, 900, true);

  const fmt = (n)=> 'KES ' + Math.round(n).toLocaleString('en-KE');

  return (
    <section id="product" className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight">Calculate Your Automation Potential</h2>
          <p className="js-reveal text-[var(--ink-soft)] mt-4" style={{animationDelay:'.05s'}}>Adjust the inputs to see illustrative productivity value for your business.</p>
        </div>
        <div className="card p-6 md:p-10 grid md:grid-cols-2 gap-10">
          <div className="flex flex-col gap-7">
            <div>
              <label className="text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)]">Industry</label>
              <select value={industry} onChange={e=>setIndustry(e.target.value)} className="w-full mt-2 border border-[var(--line)] rounded-xl px-3 py-2.5 text-sm bg-white focus:outline-none focus:ring-2 focus:ring-[var(--blue)]/30">
                {['E-commerce','Retail','Professional Services','Financial Services','Healthcare','Logistics','Other'].map(o=>(<option key={o}>{o}</option>))}
              </select>
            </div>
            <div>
              <div className="flex justify-between text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)]">
                <span>Number of Employees</span><span className="text-[var(--ink)] normal-case">{employees}</span>
              </div>
              <input type="range" min="1" max="500" value={employees} onChange={e=>setEmployees(+e.target.value)} className="w-full mt-3 accent-[#1E4FA0]"/>
            </div>
            <div>
              <div className="flex justify-between text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)]">
                <span>Repetitive Hours / Week</span><span className="text-[var(--ink)] normal-case">{hours} hrs</span>
              </div>
              <input type="range" min="2" max="40" value={hours} onChange={e=>setHours(+e.target.value)} className="w-full mt-3 accent-[#1E4FA0]"/>
            </div>
            <div>
              <div className="flex justify-between text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)]">
                <span>Average Hourly Cost</span><span className="text-[var(--ink)] normal-case">KES {rate}</span>
              </div>
              <input type="range" min="200" max="3000" step="50" value={rate} onChange={e=>setRate(+e.target.value)} className="w-full mt-3 accent-[#1E4FA0]"/>
            </div>
          </div>
          <div className="rounded-2xl bg-gradient-to-br from-[#0B1220] to-[#1E293B] text-white p-8 flex flex-col justify-center">
            <div className="text-[11px] uppercase tracking-wider text-slate-400 font-semibold">Estimated hours saved / month</div>
            <div className="font-display text-2xl font-bold mt-1">{Math.round(weeklySavedHours*4.33).toLocaleString('en-KE')} hrs</div>
            <div className="h-px bg-white/10 my-6"/>
            <div className="text-[11px] uppercase tracking-wider text-slate-400 font-semibold">Estimated Annual Productivity Value</div>
            <div className="font-display num-tick text-3xl md:text-4xl font-bold mt-1 bg-gradient-to-r from-cyan-300 to-blue-300 bg-clip-text text-transparent">{fmt(animAnnual)}</div>
            <div className="text-[10px] text-slate-500 mt-3 uppercase tracking-wide">Illustrative estimate, not a guarantee</div>
            <a href="#pricing" className="btn-primary mt-6 text-center font-semibold px-5 py-3 rounded-xl text-sm">Get Your Full ROI Report →</a>
          </div>
        </div>
      </div>
    </section>
  );
}


/* ---------------- Integrations ---------------- */
function Integrations(){
  return (
    <section id="integrations" className="py-20 px-5">
      <div className="max-w-5xl mx-auto text-center">
        <h3 className="js-reveal font-display text-xl md:text-2xl font-semibold">Works with the tools your business already uses.</h3>
        <div className="flex flex-wrap justify-center gap-3 mt-8">
          {INTEGRATIONS.map((n,i)=>(
            <div key={n} className="js-reveal card px-4 py-2.5 text-sm font-medium text-[var(--ink-soft)] hover:text-[var(--ink)] hover:shadow-md transition-all" style={{animationDelay:`${i*0.04}s`}}>
              {n}
            </div>
          ))}
        </div>
        <div className="text-[11px] text-[var(--ink-soft)] mt-6 uppercase tracking-wide">Integration-ready — availability varies by plan and region</div>
      </div>
    </section>
  );
}


/* ---------------- Feature Grid ---------------- */
function LegacyFeatureGrid(){
  const features = [
    { icon:Icon.bolt, title:'Autonomous Workflows', d:'Let AI agents execute repetitive operational workflows end-to-end, from trigger to completion.'},
    { icon:Icon.users, title:'Multi-Agent Teams', d:'Multiple specialized agents collaborate on complex, cross-functional tasks.'},
    { icon:Icon.globe, title:'Kenya-Ready Operations', d:'Support workflows relevant to local businesses, including M-Pesa-based processes.'},
    { icon:Icon.shield, title:'Human-in-the-Loop', d:'Sensitive actions can require explicit human authorization before execution.'},
  ];
  return (
    <section className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
      <div className="max-w-6xl mx-auto grid sm:grid-cols-2 lg:grid-cols-4 gap-5">
        {features.map((f,i)=>(
          <div key={f.title} className="js-reveal card p-6 hover:-translate-y-1 hover:shadow-lg transition-all duration-300" style={{animationDelay:`${i*0.08}s`}}>
            <div className="w-11 h-11 rounded-xl bg-[var(--bg-mist)] text-[var(--blue)] flex items-center justify-center mb-5">
              <f.icon className="w-5 h-5"/>
            </div>
            <div className="font-semibold text-sm mb-2">{f.title}</div>
            <div className="text-[13px] text-[var(--ink-soft)] leading-relaxed">{f.d}</div>
          </div>
        ))}
      </div>
    </section>
  );
}

/* ---------------- Human Approval Demo ---------------- */
function HumanApproval(){
  const [stage, setStage] = useState('pending'); // pending -> approving -> done
  const steps = ['Approval confirmed','Payment authorized','Transaction processed','Audit record created'];
  const [stepIdx, setStepIdx] = useState(-1);

  const approve = ()=>{
    setStage('approving');
    setStepIdx(0);
    let i=0;
    const iv = setInterval(()=>{
      i++;
      setStepIdx(i);
      if(i>=steps.length-1){ clearInterval(iv); setTimeout(()=>setStage('done'),400); }
    }, 550);
  };
  const reset = ()=>{ setStage('pending'); setStepIdx(-1); };

  return (
    <section className="py-24 px-5">
      <div className="max-w-5xl mx-auto grid lg:grid-cols-2 gap-14 items-center">
        <div>
          <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight leading-tight">Autonomous When Possible. <br/>Human When Necessary.</h2>
          <p className="js-reveal text-[var(--ink-soft)] mt-5 leading-relaxed" style={{animationDelay:'.05s'}}>
            Financial actions are never executed silently. ShaqoAI prepares the recommendation, then pauses for a real human decision — with every step recorded.
          </p>
          <ul className="js-reveal flex flex-col gap-3 mt-6 text-sm" style={{animationDelay:'.1s'}}>
            {['AI prepares recipient, amount, and reason','Execution pauses for human review','Approval or rejection is logged with full context'].map(t=>(
              <li key={t} className="flex items-start gap-2.5"><Icon.check className="w-4 h-4 text-[var(--green)] mt-0.5 shrink-0"/><span className="text-[var(--ink-soft)]">{t}</span></li>
            ))}
          </ul>
        </div>

        <div className="card p-6 shadow-xl">
          <div className="flex items-center gap-2 text-xs font-semibold text-[var(--ink-soft)] uppercase tracking-wide mb-4">
            <span className="w-6 h-6 rounded-lg bg-[var(--bg-mist)] text-[var(--blue)] inline-flex items-center justify-center"><Icon.wallet className="w-3.5 h-3.5"/></span>
            Finance Agent
          </div>
          <div className="text-sm font-semibold mb-4">Payment Authorization Required</div>
          <div className="grid grid-cols-2 gap-y-3 gap-x-4 text-xs mb-5">
            <div><div className="text-[var(--ink-soft)]">Recipient</div><div className="font-medium mt-0.5">Kenya Office Supplies Ltd.</div></div>
            <div><div className="text-[var(--ink-soft)]">Payment Method</div><div className="font-medium mt-0.5">M-Pesa</div></div>
            <div><div className="text-[var(--ink-soft)]">Amount</div><div className="font-medium mt-0.5">KES 15,000</div></div>
            <div><div className="text-[var(--ink-soft)]">Invoice</div><div className="font-medium mt-0.5">INV-1042</div></div>
            <div className="col-span-2"><div className="text-[var(--ink-soft)]">Reason</div><div className="font-medium mt-0.5">Supplier payment</div></div>
          </div>

          {stage==='pending' && (
            <div className="flex gap-3 border-t border-[var(--line)] pt-4">
              <button onClick={reset} className="btn-ghost flex-1 py-2.5 rounded-xl text-sm font-semibold">Cancel</button>
              <button onClick={approve} className="btn-primary flex-1 py-2.5 rounded-xl text-sm font-semibold">Approve Payment</button>
            </div>
          )}

          {stage!=='pending' && (
            <div className="border-t border-[var(--line)] pt-4">
              <div className="flex flex-col gap-2.5">
                {steps.map((s,i)=>(
                  <div key={s} className={`flex items-center gap-2.5 text-xs transition-all duration-300 ${i<=stepIdx ? 'opacity-100' : 'opacity-30'}`}>
                    <span className={`w-4 h-4 rounded-full flex items-center justify-center shrink-0 ${i<=stepIdx ? 'bg-[var(--green)]' : 'bg-slate-200'}`}>
                      {i<=stepIdx && <Icon.check className="w-2.5 h-2.5 text-white"/>}
                    </span>
                    {s}
                  </div>
                ))}
              </div>
              {stage==='done' && (
                <div className="mt-4 flex items-center justify-between">
                  <span className="text-xs font-semibold text-[var(--green)] flex items-center gap-1.5"><span className="dot" style={{background:'#22C55E'}}/> Success</span>
                  <button onClick={reset} className="text-xs font-semibold text-[var(--blue)]">Reset demo</button>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </section>
  );
}


/* ---------------- Operations Dashboard ---------------- */
function OperationsDashboard(){
  const [seen, setSeen] = useState(false);
  const ref = useRef(null);
  useEffect(()=>{
    const io = new IntersectionObserver(([e])=>{ if(e.isIntersecting) setSeen(true); }, {threshold:.3});
    if(ref.current) io.observe(ref.current);
    return ()=>io.disconnect();
  },[]);
  const t1 = useCountUp(1284, 1200, seen);
  const t2 = useCountUp(843, 1200, seen);
  const t3 = useCountUp(7, 900, seen);
  const t4 = useCountUp(12, 900, seen);
  const bars = [40,65,50,80,55,90,70];

  return (
    <section ref={ref} className="py-24 px-5">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight">Operations Command Center</h2>
          <p className="js-reveal text-[var(--ink-soft)] mt-4" style={{animationDelay:'.05s'}}>Full visibility into every agent, workflow, and approval.</p>
        </div>
        <div className="card p-6 md:p-8">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-5 mb-8">
            {[
              ["Today's Transactions", Math.round(t1).toLocaleString()],
              ['AI Tasks Completed', Math.round(t2).toLocaleString()],
              ['Active Agents', Math.round(t3)],
              ['Pending Approvals', Math.round(t4)],
            ].map(([label,val])=>(
              <div key={label} className="p-4 rounded-xl bg-[var(--bg-soft)] border border-[var(--line)]">
                <div className="font-display num-tick text-2xl font-bold">{val}</div>
                <div className="text-[11px] text-[var(--ink-soft)] mt-1">{label}</div>
              </div>
            ))}
          </div>
          <div className="grid md:grid-cols-3 gap-6">
            <div className="md:col-span-2 p-5 rounded-xl border border-[var(--line)]">
              <div className="text-xs font-semibold text-[var(--ink-soft)] mb-4">Workflow Completion — Last 7 Days</div>
              <div className="flex items-end gap-2.5 h-32">
                {bars.map((h,i)=>(
                  <div key={i} className="flex-1 rounded-t-md bg-gradient-to-t from-[#1E4FA0] to-[#2E7BD6] transition-all duration-700" style={{height: seen ? `${h}%` : '0%'}}/>
                ))}
              </div>
            </div>
            <div className="p-5 rounded-xl border border-[var(--line)]">
              <div className="text-xs font-semibold text-[var(--ink-soft)] mb-4">Agent Status</div>
              <div className="flex flex-col gap-3">
                {AGENTS.map(a=>(
                  <div key={a.key} className="flex items-center justify-between text-xs">
                    <span className="flex items-center gap-2"><span className="dot" style={{background:a.status==='Idle'?'#94a3b8':'#22C55E'}}/>{a.name}</span>
                    <span className="text-[var(--ink-soft)]">{a.status}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
 

/* ---------------- Security & Governance ---------------- */
function Security(){
  const cards = [
    {icon:Icon.shield, title:'Human Approval', d:'Sensitive actions require authorization before they execute.'},
    {icon:Icon.chart, title:'Audit Trails', d:'Every important AI action is recorded, end to end.'},
    {icon:Icon.lock, title:'Role-Based Access', d:'Control exactly what agents and employees can access.'},
    {icon:Icon.bolt, title:'Workflow Controls', d:'Define the rules that govern autonomous actions.'},
  ];
  const timeline = ['Agent started action','Action evaluated','Approval requested','Human approved','Action executed','Audit recorded'];
  return (
    <section className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
      <div className="max-w-6xl mx-auto">
        <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight text-center mb-14">AI You Can Trust</h2>
        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-16">
          {cards.map((c,i)=>(
            <div key={c.title} className="js-reveal card p-6" style={{animationDelay:`${i*0.07}s`}}>
              <div className="w-11 h-11 rounded-xl bg-white border border-[var(--line)] text-[var(--blue)] flex items-center justify-center mb-5"><c.icon className="w-5 h-5"/></div>
              <div className="font-semibold text-sm mb-2">{c.title}</div>
              <div className="text-[13px] text-[var(--ink-soft)] leading-relaxed">{c.d}</div>
            </div>
          ))}
        </div>
        <div className="card p-8 overflow-x-auto">
          <div className="flex items-center gap-3 min-w-[720px]">
            {timeline.map((s,i)=>(
              <React.Fragment key={s}>
                <div className="flex-1 text-center">
                  <div className="text-xs font-semibold px-3 py-3 rounded-lg bg-[var(--bg-soft)] border border-[var(--line)]">{s}</div>
                </div>
                {i<timeline.length-1 && <Icon.arrow className="w-4 h-4 text-slate-300 shrink-0"/>}
              </React.Fragment>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}


/* ---------------- How It Works ---------------- */
function LegacyHowItWorks(){
  const steps = [
    {n:'01', t:'Connect', d:'Connect the tools your business already uses.'},
    {n:'02', t:'Configure', d:'Define workflows, permissions, and business rules.'},
    {n:'03', t:'Deploy', d:'Assign specialized AI agents to your operations.'},
    {n:'04', t:'Scale', d:'Monitor performance and expand your AI workforce.'},
  ];
  return (
    <section id="how-it-works" className="py-24 px-5">
      <div className="max-w-6xl mx-auto">
        <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight text-center mb-14">How It Works</h2>
        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {steps.map((s,i)=>(
            <div key={s.n} className="js-reveal relative" style={{animationDelay:`${i*0.08}s`}}>
              <div className="font-display text-4xl font-bold text-slate-200">{s.n}</div>
              <div className="font-semibold mt-2">{s.t}</div>
              <div className="text-sm text-[var(--ink-soft)] mt-1.5 leading-relaxed">{s.d}</div>
              {i<steps.length-1 && <div className="hidden lg:block absolute top-4 -right-3 w-6 h-px bg-slate-200"/>}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}


/* ---------------- Pricing ---------------- */
function LegacyPricing(){
  const [annual, setAnnual] = useState(true);
  const plans = [
    { name:'Starter', desc:'For small teams beginning automation.', monthly:0, popular:false, features:['1 AI agent','Core integrations','Email support','Basic audit log']},
    { name:'Business', desc:'For businesses deploying multiple AI agents.', monthly:0, popular:true, features:['Up to 5 AI agents','All integrations','Priority support','Full audit trail','Human approval workflows']},
    { name:'Enterprise', desc:'For organizations requiring advanced governance.', monthly:null, popular:false, features:['Unlimited agents','Custom integrations','Dedicated support','Advanced governance','SLA & onboarding']},
  ];
  return (
    <section id="pricing" className="py-24 px-5 bg-[var(--bg-soft)] border-y border-[var(--line)]">
      <div className="max-w-6xl mx-auto">
        <div className="text-center mb-10">
          <h2 className="js-reveal font-display text-3xl md:text-4xl font-bold tracking-tight">Simple, transparent pricing</h2>
          <p className="js-reveal text-[var(--ink-soft)] mt-4" style={{animationDelay:'.05s'}}>Pricing shown is illustrative. Contact sales for a plan tailored to your business.</p>
          <div className="js-reveal inline-flex items-center gap-3 mt-8 bg-white border border-[var(--line)] rounded-full p-1" style={{animationDelay:'.1s'}}>
            <button onClick={()=>setAnnual(false)} className={`px-4 py-2 text-sm font-semibold rounded-full transition-all ${!annual ? 'bg-[var(--ink)] text-white' : 'text-[var(--ink-soft)]'}`}>Monthly</button>
            <button onClick={()=>setAnnual(true)} className={`px-4 py-2 text-sm font-semibold rounded-full transition-all ${annual ? 'bg-[var(--ink)] text-white' : 'text-[var(--ink-soft)]'}`}>Annual <span className="text-[var(--green)]">-20%</span></button>
          </div>
        </div>
        <div className="grid md:grid-cols-3 gap-6">
          {plans.map((p,i)=>(
            <div key={p.name} className={`js-reveal card p-8 flex flex-col ${p.popular ? 'border-2 border-[var(--blue)] shadow-xl relative md:-translate-y-3' : ''}`} style={{animationDelay:`${i*0.08}s`}}>
              {p.popular && <span className="absolute -top-3 left-1/2 -translate-x-1/2 bg-[var(--blue)] text-white text-[10px] font-bold px-3 py-1 rounded-full tracking-wide">MOST POPULAR</span>}
              <div className="font-display font-bold text-lg">{p.name}</div>
              <div className="text-sm text-[var(--ink-soft)] mt-1.5 mb-6">{p.desc}</div>
              <ul className="flex flex-col gap-2.5 mb-8 flex-1">
                {p.features.map(f=>(<li key={f} className="text-sm flex items-center gap-2"><Icon.check className="w-3.5 h-3.5 text-[var(--green)] shrink-0"/>{f}</li>))}
              </ul>
              <a href="/login?mode=signup" className={`text-center font-semibold py-3 rounded-xl text-sm ${p.popular ? 'btn-primary' : 'btn-ghost'}`}>{p.name==='Enterprise' ? 'Contact Sales' : 'Start Free Trial'}</a>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}


/* ---------------- Final CTA ---------------- */
function LegacyFinalCTA(){
  return (
    <section className="relative py-28 px-5 bg-gradient-to-br from-[#0B1220] to-[#13294B] overflow-hidden">
      <svg className="absolute inset-0 w-full h-full opacity-30" viewBox="0 0 800 300" preserveAspectRatio="none">
        <g stroke="#3B82F6" strokeWidth="1" fill="none">
          <path className="flow-line" d="M0,150 C200,50 400,250 800,120"/>
          <path className="flow-line" d="M0,80 C250,220 500,20 800,200" style={{animationDelay:'1s'}}/>
        </g>
      </svg>
      <div className="relative max-w-3xl mx-auto text-center text-white">
        <h2 className="js-reveal font-display text-3xl md:text-5xl font-bold tracking-tight leading-tight">Your Business Deserves a Workforce That Never Stops.</h2>
        <p className="js-reveal text-slate-300 mt-6 max-w-xl mx-auto" style={{animationDelay:'.05s'}}>Automate repetitive work, coordinate intelligent agents, and keep your team focused on the work that matters.</p>
        <div className="js-reveal flex flex-wrap justify-center gap-4 mt-9" style={{animationDelay:'.1s'}}>
          <a href="/login?mode=signup" className="btn-primary font-semibold px-6 py-3.5 rounded-xl">Build Your AI Workforce →</a>
          <a href="#" className="font-semibold px-6 py-3.5 rounded-xl border border-white/25 text-white hover:bg-white/10 transition-colors">Talk to ShaqoAI →</a>
        </div>
      </div>
    </section>
  );
}

/* ---------------- Footer ---------------- */
function LegacyFooter(){
  const cols = {
    Product:['AI Workforce','Agents','Automations','Integrations','Pricing'],
    Solutions:['Sales','Customer Support','Finance','Operations'],
    Company:['About','Careers','Contact'],
    Resources:['Documentation','Blog','Help Center'],
  };
  return (
    <footer className="pt-16 pb-8 px-5 bg-white border-t border-[var(--line)]">
      <div className="max-w-6xl mx-auto grid sm:grid-cols-2 lg:grid-cols-5 gap-10">
        <div className="lg:col-span-1">
          <div className="flex items-center gap-2 font-display font-bold text-lg"><img src={LOGO_SRC} alt="ShaqoAI" className="w-7 h-7 rounded-md object-cover"/> ShaqoAI</div>
          <div className="text-sm text-[var(--ink-soft)] mt-2">AI Workforce. Reimagined.</div>
        </div>
        {Object.entries(cols).map(([title, links])=>(
          <div key={title}>
            <div className="text-xs font-semibold uppercase tracking-wide text-[var(--ink-soft)] mb-4">{title}</div>
            <ul className="flex flex-col gap-2.5">
              {links.map(l=>(<li key={l}><a href="#" className="text-sm text-[var(--ink-soft)] hover:text-[var(--ink)] transition-colors">{l}</a></li>))}
            </ul>
          </div>
        ))}
      </div>
      <div className="max-w-6xl mx-auto mt-14 pt-6 border-t border-[var(--line)] text-xs text-[var(--ink-soft)] flex flex-col sm:flex-row justify-between gap-3">
        <span>© 2026 ShaqoAI. All rights reserved.</span>
        <span>Nairobi, Kenya · Built for African businesses</span>
      </div>
    </footer>
  );
}


/* ---------------- App ---------------- */
export function App(){
  useReveal();
  return (
    <>
      <Navigation/>
      <Hero/>
      <ImpactMetrics/>
      <AgentShowcase/>
      <AgentDirectory/>
      <RoiCalculator/>
      <Integrations/>
      <FeatureGrid/>
      <HumanApproval/>
      <OperationsDashboard/>
      <Security/>
      <HowItWorks/>
      <Pricing/>
      <FinalCTA/>
      <Footer/>
      <WhatsAppLauncher/>
    </>
  );
}
