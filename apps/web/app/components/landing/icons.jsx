import { React } from '../../utils/runtime.js';

export const Icon = {
  bolt: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M13 2 3 14h8l-1 8 10-12h-8l1-8Z" strokeLinejoin="round" strokeLinecap="round" /></svg>,
  users: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><circle cx="9" cy="8" r="3.2" /><path d="M2.5 20c1-3.6 3.6-5.5 6.5-5.5s5.5 1.9 6.5 5.5" strokeLinecap="round" /><circle cx="17.5" cy="9" r="2.6" /><path d="M15.8 14.8c2.6.2 4.6 2 5.4 5.2" strokeLinecap="round" /></svg>,
  shield: (prg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><rect x="3.5" y="5" width="17" height="15.5" rx="2.5" /><path d="M8 3v4M16 3v4M3.5 10h17" strokeLinecap="round" /></svg>,
  chart: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><path d="M4 20V10M12 20V4M20 20v-7" strokeLinecap="round" /></svg>,
  lock: (props) => <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}><rect x="4.5" y="10.5" width="15" height="10" rx="2.4" /><path d="M8 10.5V7.5a4 4 0 0 1 8 0v3" strokeLinecap="round" /></svg>,
};
