import { Icon } from './icons.jsx';

export
export const activityEvents = [
  { t: '09:42', who: 'Sales Agent', what: 'Lead captured from WhatsApp', color: '#2E7BD6' },
  { t: '09:43', who: 'Support Agent', what: 'Customer request classified', color: '#F59E0B' },
  { t: '09:44', who: 'Finance Agent', what: 'M-Pesa payment matched to invoice', color: '#14B8A6' },
  { t: '09:45', who: 'Executive Agent', what: 'Calendar updated for 3pm review', color: '#1E4FA0' },
  { t: '09:47', who: 'Sales Agent', what: 'Follow-up scheduled in HubSpot', color: '#2E7BD6' },
  { t: '09:49', who: 'Finance Agent', what: 'Payment queued for approval', color: '#14B8A6' },
];

export const agentTabs = {
  sales: { label: 'Sales Agent', steps: ['Lead Capture — WhatsApp', 'Qualification — AI Analysis', 'CRM Sync — HubSpot', 'Follow-up — Scheduled'], integrations: 'WhatsApp → ShaqoAI → HubSpot' },
  support: { label: 'Support Agent', steps: ['Customer Message', 'Intent Detection', 'Knowledge Search', 'Response Sent', 'Escalation if Needed'], integrations: 'WhatsApp / Email → ShaqoAI → Helpdesk' },
  finance: { label: 'Finance Agent', steps: ['M-Pesa Transaction', 'Transaction Matching', 'Invoice Verification', 'Human Approval', 'Receipt Issued'], integrations: 'Daraja API → ShaqoAI → Accounting' },
  executive: { label: 'Executive Agent', steps: ['Email Received', 'Prioritization', 'Task Creation', 'Calendar Update', 'Team Follow-up'], integrations: 'Gmail / Outlook → ShaqoAI → Calendar' },
};

export const integrations = ['M-Pesa', 'WhatsApp', 'Gmail', 'Google Calendar', 'Microsoft Outlook', 'HubSpot', 'Shopify', 'PostgreSQL'];
