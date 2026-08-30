import { App } from './components/main.jsx';
import { AuthPage } from './components/auth.jsx';
import { React, ReactDOM } from './utils/runtime.js';

const root = document.getElementById('root');

try {
  root.dataset.mounted = '1';
  ReactDOM.createRoot(root).render(React.createElement(window.location.pathname === '/login' ? AuthPage : App));
} catch (err) {
  root.innerHTML = '<div style="font-family:monospace;max-width:800px;margin:60px auto;padding:24px;background:#fff3f3;border:1px solid #f3b4b4;border-radius:12px;color:#7a1f1f;white-space:pre-wrap;"><strong>React failed to render.</strong>\n\n' + (err && err.message ? err.message : String(err)) + '</div>';
  console.error(err);
}
