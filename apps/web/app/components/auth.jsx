import { React, useState } from '../utils/runtime.js';

const LOGO_SRC = document.querySelector('link[rel="icon"]').href;
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function FormInput({ label, type = 'text', value, onChange, error, children }) {
  return <label className="auth-field">
    <span>{label}</span>
    <div className={`auth-input-wrap ${error ? 'auth-input-wrap--error' : ''}`}>
      <input type={type} value={value} onChange={onChange} aria-invalid={!!error} aria-describedby={error ? `${label}-error` : undefined} />
      {children}
    </div>
    {error && <em id={`${label}-error`} role="alert">{error}</em>}
  </label>;
}

function SocialButtons() {
  return <div className="auth-socials">
    <button type="button" onClick={() => {}}><span className="auth-social-icon">G</span> Continue with Google</button>
    <button type="button" onClick={() => {}}><span className="auth-social-icon auth-social-icon--m">▣</span> Continue with Microsoft</button>
  </div>;
}

function AuthVisual() {
  return <aside className="auth-brand">
    <a className="auth-logo" href="/"><img src={LOGO_SRC} alt="ShaqoAI" /> ShaqoAI</a>
    <div className="auth-brand-copy">
      <span className="auth-kicker"><i/> Intelligent opportunity network</span>
      <h1>Find your next <span>opportunity</span> with AI.</h1>
      <p>ShaqoAI connects people and opportunities through intelligent matching and human-centered recruitment.</p>
    </div>
    <div className="auth-orbit" aria-hidden="true"><span className="auth-orbit__core">✦</span><i/><i/><i/><i/><i/></div>
    <div className="auth-match-card auth-match-card--one"><small>AI MATCH</small><b>98% Match</b><span>Software Engineer</span></div>
    <div className="auth-match-card auth-match-card--two"><small>NEW OPPORTUNITY</small><b>AI Engineer</b><span>Nairobi · Hybrid</span></div>
    <div className="auth-match-card auth-match-card--three"><small>TALENT MATCHED</small><b>Excellent skill fit</b><span>Profile ready to share</span></div>
    <div className="auth-brand-foot">Trusted by future-ready teams across Africa</div>
  </aside>;
}

export function AuthPage() {
  const initialMode = new URLSearchParams(window.location.search).get('mode') === 'signup' ? 'signup' : 'login';
  const [mode, setMode] = useState(initialMode);
  const [values, setValues] = useState({ name: '', email: '', password: '', confirm: '' });
  const [errors, setErrors] = useState({});
  const [showPassword, setShowPassword] = useState(false);
  const [role, setRole] = useState('opportunities');
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState('');
  const update = key => e => setValues(v => ({ ...v, [key]: e.target.value }));
  const switchMode = next => { setMode(next); setErrors({}); setSuccess(''); window.history.replaceState({}, '', `/login?mode=${next}`); };
  const submit = e => {
    e.preventDefault();
    const next = {};
    if (mode === 'signup' && !values.name.trim()) next.name = 'Please enter your full name.';
    if (!emailPattern.test(values.email)) next.email = 'Please enter a valid email address.';
    if (values.password.length < 8) next.password = 'Password must contain at least 8 characters.';
    if (mode === 'signup' && values.password !== values.confirm) next.confirm = 'Passwords do not match.';
    setErrors(next);
    if (Object.keys(next).length) return;
    setLoading(true); setSuccess('');
    window.setTimeout(() => { setLoading(false); setSuccess(mode === 'login' ? 'Welcome to ShaqoAI' : 'Account created successfully'); }, 900);
  };
  const signup = mode === 'signup';
  return <main className="auth-page">
    <AuthVisual />
    <section className="auth-main"><a className="auth-mobile-logo" href="/"><img src={LOGO_SRC} alt="ShaqoAI"/> ShaqoAI</a>
      <div className="auth-card">
        <div className="auth-toggle" role="tablist"><button className={!signup ? 'is-active' : ''} onClick={() => switchMode('login')} role="tab">Sign In</button><button className={signup ? 'is-active' : ''} onClick={() => switchMode('signup')} role="tab">Sign Up</button></div>
        <header><h2>{signup ? 'Create your account' : 'Welcome back'}</h2><p>{signup ? 'Join the future of work with ShaqoAI' : 'Sign in to continue to ShaqoAI'}</p></header>
        {success ? <div className="auth-success" role="status"><b>✓</b> {success}<span>Frontend demonstration — no account was created.</span></div> : <form onSubmit={submit} noValidate>
          {signup && <FormInput label="Full name" value={values.name} onChange={update('name')} error={errors.name}/>} 
          <FormInput label="Email address" type="email" value={values.email} onChange={update('email')} error={errors.email}/>
          <FormInput label="Password" type={showPassword ? 'text' : 'password'} value={values.password} onChange={update('password')} error={errors.password}><button type="button" className="auth-password-toggle" onClick={() => setShowPassword(!showPassword)} aria-label={showPassword ? 'Hide password' : 'Show password'}>{showPassword ? 'Hide' : 'Show'}</button></FormInput>
          {signup && <FormInput label="Confirm password" type={showPassword ? 'text' : 'password'} value={values.confirm} onChange={update('confirm')} error={errors.confirm}/>} 
          {signup && <fieldset className="auth-role"><legend>What are you here for?</legend><div><button type="button" onClick={() => setRole('opportunities')} className={role === 'opportunities' ? 'is-selected' : ''}><span>◉</span><b>I'm looking for opportunities</b><small>Find jobs, showcase my skills, and grow my career.</small></button><button type="button" onClick={() => setRole('hiring')} className={role === 'hiring' ? 'is-selected' : ''}><span>▣</span><b>I'm hiring talent</b><small>Discover skilled professionals and build your team.</small></button></div></fieldset>}
          {!signup && <div className="auth-options"><label><input type="checkbox"/> Remember me</label><button type="button">Forgot password?</button></div>}
          <button className="auth-submit" disabled={loading}>{loading ? (signup ? 'Creating account…' : 'Signing in…') : (signup ? 'Create Account' : 'Sign In')}</button>
        </form>}
        {!success && <><div className="auth-divider"><span>or continue with</span></div><SocialButtons /></>}
        <p className="auth-switch">{signup ? 'Already have an account?' : "Don't have an account?"} <button onClick={() => switchMode(signup ? 'login' : 'signup')}>{signup ? 'Sign in' : 'Sign up'}</button></p>
      </div>
    </section>
  </main>;
}
