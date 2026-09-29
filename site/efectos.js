/* Efectos del sitio: aparición al desplazarse, contadores, inclinación de la imagen principal,
   confeti de monedas al pulsar un botón y barra de progreso. Todo se apaga si la persona
   prefiere menos movimiento. */
(() => {
  'use strict';
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
  document.documentElement.classList.add('js');

  // Barra de progreso de la lectura
  const bar = document.getElementById('progreso');
  const onScroll = () => {
    const h = document.documentElement;
    const p = h.scrollTop / Math.max(1, h.scrollHeight - h.clientHeight);
    if (bar) bar.style.transform = 'scaleX(' + Math.min(1, Math.max(0, p)) + ')';
  };
  addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  // Aparición al desplazarse
  const sel = [
    '.tarjeta', 'section h2', 'section .lead', '.dos > *', '.capturas figure', 'table', 'details',
    '.verificable', '.significado > *', '.probador-escena', '.probador-controles', '.cifras .wrap > div',
  ].join(',');
  const els = [...document.querySelectorAll(sel)];
  els.forEach((e, i) => { e.classList.add('rev'); e.style.setProperty('--d', (i % 4) * 80 + 'ms'); });
  if (reduce || !('IntersectionObserver' in window)) {
    els.forEach((e) => e.classList.add('vis'));
  } else {
    const io = new IntersectionObserver((entries) => entries.forEach((en) => {
      if (en.isIntersecting) { en.target.classList.add('vis'); io.unobserve(en.target); }
    }), { threshold: 0.12 });
    els.forEach((e) => io.observe(e));
  }

  // Contadores de las cifras
  const nums = [...document.querySelectorAll('[data-cuenta]')];
  const animar = (el) => {
    const fin = +el.dataset.cuenta;
    if (reduce) { el.textContent = fin; return; }
    const t0 = performance.now(), dur = 1100;
    const paso = (t) => {
      const k = Math.min(1, (t - t0) / dur), e = 1 - Math.pow(1 - k, 3);
      el.textContent = Math.round(fin * e);
      if (k < 1) requestAnimationFrame(paso);
    };
    requestAnimationFrame(paso);
  };
  if ('IntersectionObserver' in window) {
    nums.forEach((n) => { n.textContent = '0'; });
    const io2 = new IntersectionObserver((entries) => entries.forEach((en) => {
      if (en.isIntersecting) { animar(en.target); io2.unobserve(en.target); }
    }), { threshold: 0.6 });
    nums.forEach((n) => io2.observe(n));
  }

  if (reduce) return;

  // Inclinación de la imagen principal con el ratón
  const hero = document.querySelector('.hero'), foto = document.getElementById('foto-hero');
  if (hero && foto && matchMedia('(pointer: fine)').matches) {
    hero.addEventListener('mousemove', (ev) => {
      const r = hero.getBoundingClientRect();
      const x = (ev.clientX - r.left) / r.width - 0.5, y = (ev.clientY - r.top) / r.height - 0.5;
      foto.style.setProperty('--ry', (x * 10).toFixed(2) + 'deg');
      foto.style.setProperty('--rx', (-y * 8).toFixed(2) + 'deg');
    });
    hero.addEventListener('mouseleave', () => { foto.style.setProperty('--ry', '0deg'); foto.style.setProperty('--rx', '0deg'); });
  }

  // Confeti de monedas y estrellas al pulsar un botón
  const emojis = ['🪙', '⭐', '✨', '🪙'];
  document.addEventListener('click', (ev) => {
    const b = ev.target.closest && ev.target.closest('.btn');
    if (!b) return;
    for (let i = 0; i < 14; i++) {
      const s = document.createElement('span');
      s.className = 'confeti';
      s.textContent = emojis[i % emojis.length];
      const ang = (Math.PI * 2 * i) / 14 + Math.random() * 0.5, d = 60 + Math.random() * 90;
      s.style.left = ev.clientX + 'px';
      s.style.top = ev.clientY + 'px';
      s.style.setProperty('--dx', Math.cos(ang) * d + 'px');
      s.style.setProperty('--dy', Math.sin(ang) * d - 40 + 'px');
      s.style.setProperty('--g', 80 + Math.random() * 60 + 'px');
      document.body.appendChild(s);
      setTimeout(() => s.remove(), 1000);
    }
  });
})();
