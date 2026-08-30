import { React } from '../../utils/runtime.js';

export const Icon = {
  bolt: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M13 2 3 14h8l-1 8 10-12h-8l1-8Z" strokeLinejoin="round" strokeLinecap="round" /></svg>,
  users: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><circle cx="9" cy="8" r="3.2" /><path d="M2.5 20c1-3.6 3.6-5.5 6.5-5.5s5.5 1.9 6.5 5.5" strokeLinecap="round" /><circle cx="17.5" cy="9" r="2.6" /><path d="M15.8 14.8c2.6.2 4.6 2 5.4 5.2" strokeLinecap="round" /></svg>,
  shield: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M12 3l7 3v6c0 4.6-3 8.2-7 9-4-.8-7-4.4-7-9V6l7-3Z" strokeLinejoin="round" /><path d="m9 12 2 2 4-4" strokeLinecap="round" strokeLinejoin="round" /></svg>,
  globe: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><circle cx="12" cy="12" r="9" /><path d="M3 12h18M12 3c2.7 2.6 4 5.7 4 9s-1.3 6.4-4 9c-2.7-2.6-4-5.7-4-9s1.3-6.4 4-9Z" /></svg>,
  check: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" {...props}><path d="m4 12 5.5 5.5L20 7" strokeLinecap="round" strokeLinejoin="round" /></svg>,
  arrow: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" {...props}><path d="M5 12h14M13 6l6 6-6 6" strokeLinecap="round" strokeLinejoin="round" /></svg>,
  menu: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M4 7h16M4 12h16M4 17h16" strokeLinecap="round" /></svg>,
  close: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M6 6l12 12M18 6 6 18" strokeLinecap="round" /></svg>,
  play: (props) => <svg viewBox="0 0 24 24" fill="currentColor" {...props}><path d="M8 5.5v13l11-6.5-11-6.5Z" /></svg>,
  wallet: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><rect x="3" y="6" width="18" height="13" rx="2.5" /><path d="M3 10h18" /><circle cx="16" cy="14" r="1.3" fill="currentColor" stroke="none" /></svg>,
  chat: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M4 5.5h16v11H9l-5 4v-4H4v-11Z" strokeLinejoin="round" /></svg>,
  calendar: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><rect x="3.5" y="5" width="17" height="15.5" rx="2.5" /><path d="M8 3v4M16 3v4M3.5 10h17" strokeLinecap="round" /></svg>,
  chart: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M4 20V10M12 20V4M20 20v-7" strokeLinecap="round" /></svg>,
  lock: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><rect x="4.5" y="10.5" width="15" height="10" rx="2.4" /><path d="M8 10.5V7.5a4 4 0 0 1 8 0v3" strokeLinecap="round" /></svg>,
};
