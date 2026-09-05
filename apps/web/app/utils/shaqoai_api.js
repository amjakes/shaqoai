const baseUrl = (import.meta.env.VITE_API_BASE_URL || '').replace(/\/$/, '');

function session() {
  try { return JSON.parse(window.localStorage.getItem('shaqoai_session') || 'null'); } catch { return null; }
}

export async function loadSupportConversations() {
  const auth = session();
  if (!baseUrl || !auth?.accessToken || !auth?.workspaceId) return null;
  const response = await fetch(`${baseUrl}/api/v1/support/conversations`, { headers: { Authorization: `Bearer ${auth.accessToken}`, 'X-Workspace-ID': auth.workspaceId } });
  if (!response.ok) throw new Error('Could not load support conversations');
  return response.json();
}
