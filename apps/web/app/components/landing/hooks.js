import { useEffect, useRef, useState } from '../../utils/runtime.js';

export function useReveal() {
  useEffect(() => {
    const elements = document.querySelectorAll('.js-reveal');
    const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('reveal');
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: .15 });
    elements.forEach((element) => observer.observe(element));
    return () => observer.disconnect();
  });
}

export function useCountUp(target, duration = 1400, trigger = true) {
  const [value, setValue] = useState(0);
  const frameRef = useRef(null);
  useEffect(() => {
    if (!trigger) return undefined;
    let start;
    const step = (time) => {
      if (!start) start = time;
      const progress = Math.min(1, (time - start) / duration);
      setValue(target * (1 - Math.pow(1 - progress, 3)));
      if (progress < 1) frameRef.current = requestAnimationFrame(step);
    };
    frameRef.current = requestAnimationFrame(step);
    return () => cancelAnimationFrame(frameRef.current);
  }, [target, trigger, duration]);
  return value;
}
