import { React, useEffect, useState } from '../../utils/runtime.js';
import { loadSupportConversations } from '../../utils/shaqoai_api.js';

const agents = [
  ['💼', 'Amara', 'AI Business Development Manager'], ['📈', 'Sarah', 'AI Sales Representative'],
  ['📱', 'Jordan', 'AI Social Media Manager'], ['✍️', 'Maya', 'AI Content Writer'],
  ['🔎', 'Elena', 'AI Research Analyst'], ['📋', 'Farah', 'AI Tender & Proposal Specialist'],
  ['👥', 'Deka', 'AI HR Manager'], ['💰', 'Kevin', 'AI Finance Assistant'],
  ['🎧', 'Zara', 'AI Customer Support Agent'], ['🗓️', 'Grace', 'AI Executive Assistant'],
  ['👨‍🏫', 'Nadia', 'AI Teacher / Tutor'], ['🗣️', 'Layla', 'AI Language Teacher'],
  ['💻', 'Marcus', 'AI Software Developer'], ['🎨', 'Leo', 'AI Graphic Designer'],
  ['⚖️', 'Victor', 'AI Legal Assistant'], ['🏥', 'Naima', 'AI Medical Administrative Assistant'],
  ['🛒', 'Priya', 'AI E-commerce Manager'], ['🧑‍💼', 'Daniel', 'AI Project Manager'],
  ['📊', 'Chen', 'AI Data Analyst'], ['📢', 'Aisha', 'AI Marketing Manager'],
  ['🧑‍💻', 'Ryan', 'AI IT Support Specialist'], ['📄', 'Fatima', 'AI Resume & Career Coach'],
  ['🌍', 'Noah', 'AI Travel Planner'], ['🏢', 'Halima', 'AI Operations Manager'],
  ['🧠', 'Sam', 'AI Personal Productivity Coach'],
];

export function WhatsAppLauncher() {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const [showNotice, setShowNotice] = useState(true);
  const [conversations, setConversations] = useState(null);
  useEffect(() => {
    if (!open) return;
    loadSupportConversations().then((items) => items && setConversations(items)).catch(() => setConversations([]));
  }, [open]);
  const chats = conversations ?? agents.map(([emoji, name, role]) => ({ emoji, name, role, status: 'active' }));
  const matches = chats.filter((chat) => `${chat.name} ${chat.role}`.toLowerCase().includes(query.toLowerCase()));
  return <>
    <button onClick={() => setOpen(true)} aria-label="Open ShaqoAI WhatsApp" className="fixed z-40 right-5 bottom-5 sm:right-8 sm:bottom-8 w-14 h-14 rounded-full bg-[#25D366] text-[#101113] shadow-[0_10px_28px_rgba(37,211,102,.35)] hover:scale-105 transition-transform flex items-center justify-center"><svg viewBox="0 0 24 24" fill="currentColor" className="w-7 h-7"><path d="M12.04 2C6.5 2 2 6.49 2 12.03c0 1.77.46 3.49 1.33 5L2 22l5.1-1.3a10.04 10.04 0 0 0 4.94 1.3h.01c5.54 0 10.04-4.49 10.04-10.03A10.03 10.03 0 0 0 12.04 2Zm5.84 14.18c-.25.7-1.44 1.33-1.98 1.41-.5.07-1.14.1-1.84-.13-.42-.13-.96-.31-1.66-.61-2.91-1.26-4.81-4.2-4.95-4.39-.14-.19-1.18-1.57-1.18-3 0-1.43.75-2.13 1.01-2.42.27-.29.59-.36.78-.36.2 0 .39 0 .56.01.18.01.42-.07.65.48.24.57.81 1.98.88 2.12.07.14.12.31.02.5-.1.2-.15.31-.3.47-.14.16-.3.35-.43.47-.14.14-.28.3-.12.58.16.28.7 1.15 1.5 1.87 1.03.92 1.9 1.2 2.18 1.34.28.14.44.12.6-.07.16-.2.69-.8.87-1.07.18-.27.36-.23.6-.14.25.08 1.58.75 1.85.89.27.13.45.2.52.31.06.11.06.65-.19 1.35Z" /></svg></button>
    {open && <div className="fixed inset-0 z-[70] bg-black/55 backdrop-blur-sm p-0 sm:p-5 flex justify-center sm:items-center" role="dialog" aria-modal="true" aria-label="ShaqoAI WhatsApp">
      <div className="w-full h-full sm:h-[min(860px,92vh)] sm:max-w-[660px] bg-[#101113] text-white sm:rounded-2xl overflow-hidden shadow-2xl flex flex-col">
        <header className="px-5 pt-5 pb-3 flex items-center gap-3"><h2 className="text-3xl font-bold tracking-tight">WhatsApp</h2><div className="ml-auto flex items-center gap-3"><button className="p-2 text-white/90" aria-label="More options">⋮</button><button className="w-12 h-12 rounded-full bg-[#25D366] text-[#101113] text-3xl font-bold leading-none" aria-label="Start new chat">+</button><button onClick={() => setOpen(false)} className="p-2 text-white/90 text-2xl leading-none" aria-label="Close WhatsApp">×</button></div></header>
        <div className="px-4 pb-2"><label className="h-[60px] rounded-full bg-[#2B2D2F] flex items-center px-5 gap-4"><span className="text-3xl text-[#B7B2AC] leading-none">⌕</span><input autoFocus value={query} onChange={(event) => setQuery(event.target.value)} className="w-full bg-transparent outline-none text-lg placeholder:text-[#B7B2AC]" placeholder="Search or start a new chat" /></label></div>
        <div className="px-4 pt-2 pb-3 flex gap-2 overflow-x-auto whitespace-nowrap"><Filter label="All" selected /><Filter label="Favourites" /><Filter label="Unread 25" /><Filter label="Groups" /><button className="w-12 h-12 shrink-0 rounded-full border border-white/15 text-3xl text-[#B7B2AC]">+</button></div>
        <main className="flex-1 overflow-y-auto px-4 pb-6">{showNotice && <div className="my-2 rounded-[22px] bg-[#073B2B] px-5 py-4 flex items-center gap-4"><span className="text-[#25D366] text-3xl">♨</span><p className="flex-1 text-base font-semibold">Message notifications are off. <button className="text-[#25D366] font-bold">Turn on</button></p><button onClick={() => setShowNotice(false)} className="text-3xl text-white/90">×</button></div>}<div className="px-4 py-5 flex items-center gap-6 text-[#B7B2AC]"><span className="text-2xl">▣</span><span className="text-lg">Archived</span><span className="ml-auto text-sm">8</span></div>{matches.map((chat) => <button key={chat.id ?? chat.name} className="w-full text-left px-2 py-3 flex items-center gap-4 hover:bg-white/5 rounded-2xl transition-colors"><span className="w-14 h-14 rounded-full bg-[#2B2D2F] flex items-center justify-center text-2xl">{chat.emoji ?? '💬'}</span><span className="min-w-0 flex-1"><span className="block text-lg font-semibold">{chat.name ?? chat.sender}</span><span className="block truncate mt-1 text-[15px] text-[#B7B2AC]">{chat.last_message ?? `${chat.role} · Works 24/7`}</span></span><span className="self-start text-sm text-[#25D366]">{chat.status === 'active' ? 'Now' : chat.status}</span></button>)}{!matches.length && <p className="text-center text-[#B7B2AC] py-16">No conversations found</p>}</main>
      </div>
    </div>}
  </>;
}

function Filter({ label, selected = false }) {
  return <button className={`h-12 shrink-0 rounded-full px-4 border font-semibold text-lg ${selected ? 'bg-[#103B2B] border-[#176B49] text-[#A8F2CE]' : 'border-white/15 text-[#B7B2AC]'}`}>{label}</button>;
}
