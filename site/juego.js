/* Probador de personajes de Ritmo: usa los mismos dibujos y la misma lógica de capas que la app
   (recoloreado exacto de la paleta, ropa ajustada al cuerpo, ropa interior, sombreros que tapan el pelo). */
(() => {
  'use strict';
  const BASE = 'juego/';
  const W = 64, H = 96, SW = 384, SH = 192;
  let U = 3, CU = 4; // píxeles de pantalla por píxel del fondo y del personaje (enteros, se ajustan a la pantalla)

  // ---- Datos (los mismos de app/lib/pixel) ----
  const SKINS = [
    ['Marfil', 0xFFE3CF, 0xF6CDB1, 0xD9A585], ['Claro', 0xFBD5B5, 0xEDB98F, 0xC98F68],
    ['Beige', 0xF2C79C, 0xE2AA7B, 0xB98058], ['Dorado', 0xE8B77F, 0xD39A62, 0xA87445],
    ['Canela', 0xD39A6A, 0xB87B4D, 0x8F5B36], ['Caramelo', 0xB87B50, 0x9A6035, 0x744423],
    ['Moreno', 0x8D5A3B, 0x734529, 0x54301C], ['Ébano', 0x6A4030, 0x52301F, 0x3A2015],
  ];
  const SKIN_DRAWN = [0xE8B77F, 0xD39A62, 0xA87445];
  const HAIR_DRAWN = [0xA9714B, 0x6E4530];
  const HAIRS = [
    ['Negro', 0x3A3446, 0x2B2340], ['Chocolate', 0x5A3A2A, 0x3B2318], ['Castaño', 0xA9714B, 0x6E4530],
    ['Miel', 0xE0B070, 0xB0803F], ['Rubio', 0xF2D27A, 0xC9A34A], ['Pelirrojo', 0xD9642B, 0xA2401A],
    ['Gris', 0xB8B4C4, 0x8C84A8], ['Blanco', 0xF4F0F8, 0xC9C4DB], ['Rosa', 0xFF8FAB, 0xD65A7E],
    ['Celeste', 0x7EC8F5, 0x4F6AF5], ['Verde', 0x5CC28A, 0x2F8F6B], ['Lila', 0xB69CF2, 0x7C5FCF],
  ];
  const EYE_DRAWN = [0x4F6AF5, 0x3446B8];
  const EYES = [
    ['Azul', 0x4F6AF5, 0x3446B8], ['Verde', 0x5CC28A, 0x2F8F6B], ['Marrón', 0x8B5A3A, 0x5E3B24],
    ['Gris', 0x94A0B8, 0x66728C], ['Violeta', 0xB69CF2, 0x7C5FCF], ['Ámbar', 0xF0A83C, 0xC97A1E],
  ];
  const EYE_STYLES = [
    ['clasicos', 'Clásicos'], ['grandes', 'Grandes'], ['dulces', 'Dulces'], ['brillantes', 'Brillantes'],
    ['almendrados', 'Almendrados'], ['sonolientos', 'Soñolientos'], ['felices', 'Felices'],
    ['decididos', 'Decididos'], ['puntitos', 'Puntitos'],
  ];
  const ITEM_DRAWN = [0xFF8FAB, 0xD65A7E];
  const COLORS = [
    ['Rosa', 0xFF8FAB, 0xD65A7E], ['Rojo', 0xE8505B, 0xB13E53], ['Naranja', 0xFFAA6B, 0xD9782F],
    ['Amarillo', 0xFFD866, 0xE0A83A], ['Verde', 0x5CC28A, 0x2F8F6B], ['Turquesa', 0x6ED3D0, 0x3AA5A8],
    ['Celeste', 0x7EC8F5, 0x4F6AF5], ['Azul', 0x4F6AF5, 0x3446B8], ['Lila', 0xB69CF2, 0x7C5FCF],
    ['Blanco', 0xF4F0F8, 0xC9C4DB], ['Gris', 0x8C84A8, 0x4A3F6B], ['Negro', 0x4A3F6B, 0x2B2340],
  ];
  const FRAME_DRAWN = [0x2B2340, 0x2B2340];
  const FRAMES = [
    ['Plateado', 0xB8B4C4], ['Dorado', 0xE0B070], ['Marrón', 0x8B5A3A], ['Rosa', 0xFF8FAB],
    ['Celeste', 0x7EC8F5], ['Verde', 0x5CC28A], ['Lila', 0xB69CF2], ['Rojo', 0xE8505B],
    ['Blanco', 0xF4F0F8], ['Negro', 0x2B2340],
  ].map(([n, c]) => [n, c, c]);
  const BODIES = [['hombre_a', 'Hombre A'], ['hombre_b', 'Hombre B'], ['mujer_a', 'Mujer A'], ['mujer_b', 'Mujer B']];
  const MUSCLE = ['Principiante', 'Activo', 'Atlético', 'Fuerte', 'Legendario'];
  const WOMEN = ['mujer_a', 'mujer_b'];
  const SLOTS = [
    ['sombrero', 'Sombrero'], ['cara', 'Anteojos'], ['auriculares', 'Auriculares'], ['torso', 'Torso'],
    ['piernas', 'Piernas'], ['pies', 'Pies'], ['traje', 'Vestido'],
  ];
  const PER_BODY = ['torso', 'piernas', 'pies', 'traje'];
  const ITEMS = [
    { id: 'gorra', n: 'Gorra', s: 'sombrero', rc: 'item', hair: true },
    { id: 'gorro_lana', n: 'Gorro de lana', s: 'sombrero', rc: 'item', hair: true, dy: -8 },
    { id: 'sombrero_pescador', n: 'Sombrero de pescador', s: 'sombrero', rc: 'item', hair: true },
    { id: 'cinta_deportiva', n: 'Cinta deportiva', s: 'sombrero', rc: 'item' },
    { id: 'mono_pelo', n: 'Moño', s: 'sombrero', rc: 'item' },
    { id: 'orejas_gato', n: 'Orejas de gato', s: 'sombrero', rc: 'item' },
    { id: 'corona_flores', n: 'Corona de flores', s: 'sombrero', rc: 'item' },
    { id: 'sombrero_paja', n: 'Sombrero de paja', s: 'sombrero', rc: 'item', hair: true, dy: -4 },
    { id: 'sombrero_mago', n: 'Sombrero de mago', s: 'sombrero', rc: 'item', hair: true, dy: -5, cut: 30 },
    { id: 'anteojos', n: 'Redondos', s: 'cara', rc: 'frame' },
    { id: 'anteojos_cuadrados', n: 'Cuadrados', s: 'cara', rc: 'frame' },
    { id: 'anteojos_ojo_gato', n: 'Ojo de gato', s: 'cara', rc: 'frame' },
    { id: 'anteojos_hexagonales', n: 'Hexagonales', s: 'cara', rc: 'frame' },
    { id: 'anteojos_medio_marco', n: 'Medio marco', s: 'cara', rc: 'frame' },
    { id: 'auriculares', n: 'Auriculares', s: 'auriculares', rc: 'item' },
    { id: 'camiseta', n: 'Camiseta', s: 'torso', rc: 'item', fit: 1 },
    { id: 'buzo', n: 'Buzo con capucha', s: 'torso', rc: 'item', fit: 2 },
    { id: 'pantalon', n: 'Pantalón', s: 'piernas', rc: 'item', under: true, fit: 1 },
    { id: 'short', n: 'Short', s: 'piernas', rc: 'item', under: true, fit: 1 },
    { id: 'pollera', n: 'Pollera', s: 'piernas', rc: 'item', under: true, women: true },
    { id: 'zapatillas', n: 'Zapatillas', s: 'pies', rc: 'item', fit: 1 },
    { id: 'vestido', n: 'Vestido de verano', s: 'traje', rc: 'item', under: true, women: true, hides: ['torso', 'piernas'] },
  ];
  const BGS = [
    ['dormitorio', 'Dormitorio'], ['parque', 'Parque'], ['gimnasio', 'Gimnasio'], ['cocina', 'Cocina'],
    ['biblioteca', 'Biblioteca'], ['cafe', 'Café'], ['playa', 'Playa'], ['bosque', 'Bosque mágico'],
    ['azotea', 'Azotea de noche'], ['jardin', 'Jardín japonés'], ['cabana', 'Cabaña con nieve'],
    ['estacion', 'Estación espacial'], ['oasis', 'Oasis'],
  ];
  const UNDER = [0x8C84A8, 0xC9C4DB, 0x4A3F6B];
  const UNDER_SPLIT = 52;
  const OUTLINE = [0x2B, 0x23, 0x40];

  // ---- Utilidades de píxeles ----
  const cache = new Map();
  function loadData(url) {
    if (!cache.has(url)) {
      cache.set(url, new Promise((res, rej) => {
        const im = new Image();
        im.onload = () => {
          const c = document.createElement('canvas');
          c.width = im.width; c.height = im.height;
          const x = c.getContext('2d', { willReadFrequently: true });
          x.drawImage(im, 0, 0);
          res(x.getImageData(0, 0, im.width, im.height));
        };
        im.onerror = () => rej(new Error('No se pudo cargar ' + url));
        im.src = url;
      }));
    }
    return cache.get(url);
  }
  const clone = (d) => new ImageData(new Uint8ClampedArray(d.data), d.width, d.height);
  const key = (p, i) => (p[i] << 16) | (p[i + 1] << 8) | p[i + 2];
  const pairMap = (from, to) => new Map([[from[0], to[1]], [from[1], to[2] !== undefined ? to[2] : to[1]]]);
  const setRgb = (p, i, c) => { p[i] = (c >> 16) & 255; p[i + 1] = (c >> 8) & 255; p[i + 2] = c & 255; };

  function recolor(d, map) {
    const o = clone(d), p = o.data;
    for (let i = 0; i < p.length; i += 4) {
      if (!p[i + 3]) continue;
      const to = map.get(key(p, i));
      if (to !== undefined) setRgb(p, i, to);
    }
    return o;
  }

  // Ajusta la prenda al cuerpo: borra lo que pasa más de `margin` píxeles de la silueta y da un contorno nuevo.
  function fitGarment(g, body, margin) {
    const o = clone(g), p = o.data, b = body.data, w = g.width, h = g.height;
    const near = (x, y) => {
      for (let dy = -margin; dy <= margin; dy++) for (let dx = -margin; dx <= margin; dx++) {
        const nx = x + dx, ny = y + dy;
        if (nx >= 0 && ny >= 0 && nx < w && ny < h && b[(ny * w + nx) * 4 + 3] > 0) return true;
      }
      return false;
    };
    for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
      const i = (y * w + x) * 4;
      if (p[i + 3] && !near(x, y)) { p[i] = p[i + 1] = p[i + 2] = p[i + 3] = 0; }
    }
    const empty = (x, y) => x < 0 || y < 0 || x >= w || y >= h || !p[(y * w + x) * 4 + 3];
    const edge = [];
    for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
      if (!p[(y * w + x) * 4 + 3]) continue;
      if (empty(x - 1, y) || empty(x + 1, y) || empty(x, y - 1) || empty(x, y + 1)) edge.push((y * w + x) * 4);
    }
    edge.forEach((i) => { p[i] = OUTLINE[0]; p[i + 1] = OUTLINE[1]; p[i + 2] = OUTLINE[2]; });
    return o;
  }

  // Cuerpo con ropa: ropa interior del color de la prenda y contorno pegado a las prendas.
  function dress(body, top, legs, garments) {
    if (!top && !legs && !garments.length) return body;
    const o = clone(body), p = o.data, w = body.width, h = body.height;
    for (let y = 0; y < h; y++) {
      const map = y < UNDER_SPLIT ? top : legs;
      if (!map) continue;
      for (let x = 0; x < w; x++) {
        const i = (y * w + x) * 4;
        if (!p[i + 3]) continue;
        const to = map.get(key(p, i));
        if (to !== undefined) setRgb(p, i, to);
      }
    }
    if (garments.length) {
      const mask = new Uint8Array(w * h);
      garments.forEach((g) => { for (let i = 0; i < w * h; i++) if (g.data[i * 4 + 3]) mask[i] = 1; });
      const src = new Uint8ClampedArray(p);
      for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
        const i = y * w + x;
        if (!src[i * 4 + 3] || mask[i]) continue;
        let near = false;
        for (let dy = -1; dy <= 1 && !near; dy++) for (let dx = -1; dx <= 1; dx++) {
          const nx = x + dx, ny = y + dy;
          if (nx >= 0 && ny >= 0 && nx < w && ny < h && mask[ny * w + nx]) { near = true; break; }
        }
        if (near) { p[i * 4] = OUTLINE[0]; p[i * 4 + 1] = OUTLINE[1]; p[i * 4 + 2] = OUTLINE[2]; }
      }
    }
    return o;
  }

  function cutTop(d, row) {
    const o = clone(d);
    for (let y = 0; y < row && y < d.height; y++) for (let x = 0; x < d.width; x++) {
      const i = (y * d.width + x) * 4; o.data[i] = o.data[i + 1] = o.data[i + 2] = o.data[i + 3] = 0;
    }
    return o;
  }

  // Rosas y magentas → azul (mismo giro de tono que la app).
  function pinkToBlue(d) {
    const o = clone(d), p = o.data;
    for (let i = 0; i < p.length; i += 4) {
      if (!p[i + 3]) continue;
      const r = p[i] / 255, g = p[i + 1] / 255, b = p[i + 2] / 255;
      const mx = Math.max(r, g, b), mn = Math.min(r, g, b), dd = mx - mn;
      if (dd < 0.08) continue;
      let h = mx === r ? 60 * (((g - b) / dd) % 6) : mx === g ? 60 * ((b - r) / dd + 2) : 60 * ((r - g) / dd + 4);
      if (h < 0) h += 360;
      if (h < 290 || h > 360) continue;
      const nh = h - 130, l = (mx + mn) / 2, c = dd;
      const x = c * (1 - Math.abs(((nh / 60) % 2) - 1)), m = l - c / 2;
      const [rr, gg, bb] = nh < 180 ? [0, c, x] : nh < 240 ? [0, x, c] : [x, 0, c];
      p[i] = Math.round((rr + m) * 255); p[i + 1] = Math.round((gg + m) * 255); p[i + 2] = Math.round((bb + m) * 255);
    }
    return o;
  }

  const toCanvas = (d) => {
    const c = document.createElement('canvas');
    c.width = d.width; c.height = d.height;
    c.getContext('2d').putImageData(d, 0, 0);
    return c;
  };

  // ---- Estado y composición ----
  const S = {
    body: 'mujer_b', lvl: 1, skin: 3, hair: 8, eyeColor: 0, eyeStyle: 0, color: 7, frame: 0,
    bg: 'parque', tone: 1,
    eq: { sombrero: 'gorra', cara: null, auriculares: null, torso: 'buzo', piernas: 'pantalon', pies: 'zapatillas', traje: null },
  };
  let anchors = null, current = null, bob = 0, renderId = 0;
  const itemById = (id) => ITEMS.find((i) => i.id === id);
  const itemUrl = (it) => BASE + 'items/' + it.id + '/' + (PER_BODY.includes(it.s) ? S.body : it.id) + '_' + S.lvl + '.png';
  const pairOf = (it) => (it.rc === 'frame' ? FRAMES[S.frame] : COLORS[S.color]);
  const drawnOf = (it) => (it.rc === 'frame' ? FRAME_DRAWN : ITEM_DRAWN);

  async function buildAvatar() {
    const lvl = S.lvl;
    if (!anchors) anchors = await (await fetch(BASE + 'anclajes_cabeza.json')).json();
    const a = anchors['base_' + S.body][lvl];
    const skin = SKINS[S.skin];
    const skinMap = new Map([[SKIN_DRAWN[0], skin[1]], [SKIN_DRAWN[1], skin[2]], [SKIN_DRAWN[2], skin[3]]]);

    // Objetos puestos (uno por ranura, solo los que existen para este cuerpo; el traje tapa torso y piernas)
    const worn = {};
    SLOTS.forEach(([slot]) => {
      const it = itemById(S.eq[slot]);
      if (it && it.s === slot && (!it.women || WOMEN.includes(S.body))) worn[slot] = it;
    });
    Object.values(worn).slice().forEach((it) => (it.hides || []).forEach((s) => delete worn[s]));
    const hideHair = Object.values(worn).some((it) => it.hair);

    const rawBody = recolor(await loadData(BASE + 'body/' + S.body + '_' + lvl + '.png'), skinMap);
    const garments = [];
    for (const slot of ['piernas', 'torso', 'traje', 'pies']) {
      const it = worn[slot];
      if (!it) continue;
      let img = recolor(await loadData(itemUrl(it)), pairMap(drawnOf(it), pairOf(it)));
      if (it.fit !== undefined) img = fitGarment(img, rawBody, it.fit);
      garments.push({ it, img });
    }
    const under = (it) => { const c = pairOf(it); return new Map([[UNDER[0], c[1]], [UNDER[1], c[1]], [UNDER[2], c[2]]]); };
    const topW = worn.torso || worn.traje, legW = worn.piernas || worn.traje;
    const bodyImg = dress(rawBody, topW ? under(topW) : null, legW && legW.under ? under(legW) : null, garments.map((g) => g.img));

    const head = recolor(await loadData(BASE + 'head/cabeza_' + lvl + '.png'), skinMap);
    const cut = Math.max(0, ...Object.values(worn).map((it) => it.cut || 0));
    const eyes = recolor(await loadData(BASE + 'eyes/' + EYE_STYLES[S.eyeStyle][0] + '_' + lvl + '.png'), pairMap(EYE_DRAWN, EYES[S.eyeColor]));
    const mouth = await loadData(BASE + 'mouth/sonrisa_' + lvl + '.png');
    const hair = recolor(await loadData(BASE + 'hair/pelo_1_' + lvl + '.png'), pairMap(HAIR_DRAWN, HAIRS[S.hair]));

    const layers = [{ d: bodyImg, x: 0, y: 0 }];
    garments.forEach((g) => layers.push({ d: g.img, x: 0, y: 0 }));
    layers.push({ d: cut ? cutTop(head, cut) : head, x: a.dx, y: a.dy }, { d: eyes, x: a.dx, y: a.dy }, { d: mouth, x: a.dx, y: a.dy });
    if (!hideHair) layers.push({ d: hair, x: a.dx, y: a.dy });
    for (const slot of ['sombrero', 'cara', 'auriculares']) {
      const it = worn[slot];
      if (!it) continue;
      layers.push({ d: recolor(await loadData(itemUrl(it)), pairMap(drawnOf(it), pairOf(it))), x: a.dx, y: a.dy + (it.dy || 0) });
    }
    return layers.map((l) => ({ c: toCanvas(l.d), x: l.x, y: l.y }));
  }

  async function buildBackground() {
    let d = await loadData(BASE + 'bg/' + S.bg + '.png');
    if (S.tone === 1) d = pinkToBlue(d);
    return toCanvas(d);
  }

  const canvas = document.getElementById('juego-lienzo');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  // El lienzo se dibuja a un tamaño ENTERO de píxeles de pantalla por píxel de arte. Si se dibujara más grande y
  // el navegador lo redujera, saltaría filas y columnas y el personaje se llenaría de puntitos.
  function medir() {
    const dpr = window.devicePixelRatio || 1;
    const ancho = (canvas.parentElement && canvas.parentElement.clientWidth) || 600;
    U = Math.min(6, Math.max(1, Math.floor((ancho * dpr) / SW)));
    CU = Math.max(U + 1, Math.floor(U * 1.5));
    canvas.width = SW * U; canvas.height = SH * U;
    canvas.style.width = (SW * U) / dpr + 'px';
    canvas.style.height = (SH * U) / dpr + 'px';
  }
  medir();
  let temporizador = 0;
  window.addEventListener('resize', () => {
    clearTimeout(temporizador);
    temporizador = setTimeout(() => { medir(); paint(); }, 120);
  });

  function paint() {
    if (!current) return;
    ctx.imageSmoothingEnabled = false;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(current.bg, 0, 0, SW * U, SH * U);
    const x0 = (SW * U - W * CU) / 2, y0 = (SH - 16) * U - H * CU - bob * CU;
    current.layers.forEach((l) => ctx.drawImage(l.c, x0 + l.x * CU, y0 + l.y * CU, l.c.width * CU, l.c.height * CU));
  }

  async function render() {
    const id = ++renderId;
    try {
      const [layers, bg] = await Promise.all([buildAvatar(), buildBackground()]);
      if (id !== renderId) return;
      current = { layers, bg };
      paint();
      canvas.classList.add('listo');
    } catch (e) { console.warn(e); }
  }
  if (!matchMedia('(prefers-reduced-motion: reduce)').matches) {
    setInterval(() => { bob = bob ? 0 : 1; paint(); }, 700);
  }

  // ---- Controles ----
  const $ = (id) => document.getElementById(id);
  function chips(el, options, isSel, pick) {
    el.innerHTML = '';
    options.forEach(([val, label, extra]) => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'chip' + (isSel(val) ? ' sel' : '');
      b.textContent = label;
      if (extra) b.disabled = true;
      b.onclick = () => { pick(val); refresh(); render(); };
      el.appendChild(b);
    });
  }
  function swatches(el, list, isSel, pick, label) {
    el.innerHTML = '';
    list.forEach((c, i) => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'sw' + (isSel(i) ? ' sel' : '');
      b.style.background = '#' + c[c.length === 4 ? 2 : 1].toString(16).padStart(6, '0');
      b.title = c[0]; b.setAttribute('aria-label', label + ': ' + c[0]);
      b.onclick = () => { pick(i); refresh(); render(); };
      el.appendChild(b);
    });
  }
  function refresh() {
    const woman = WOMEN.includes(S.body);
    chips($('c-cuerpo'), BODIES, (v) => S.body === v, (v) => { S.body = v; if (!WOMEN.includes(v)) SLOTS.forEach(([s]) => { const it = itemById(S.eq[s]); if (it && it.women) S.eq[s] = null; }); });
    $('c-musculo-etiqueta').textContent = MUSCLE[S.lvl];
    $('c-musculo').value = S.lvl;
    swatches($('c-piel'), SKINS, (i) => S.skin === i, (i) => { S.skin = i; }, 'Piel');
    swatches($('c-pelo'), HAIRS, (i) => S.hair === i, (i) => { S.hair = i; }, 'Pelo');
    swatches($('c-ojos-color'), EYES, (i) => S.eyeColor === i, (i) => { S.eyeColor = i; }, 'Ojos');
    chips($('c-ojos-forma'), EYE_STYLES.map(([v, l]) => [v, l]), (v) => EYE_STYLES[S.eyeStyle][0] === v, (v) => { S.eyeStyle = EYE_STYLES.findIndex((e) => e[0] === v); });
    swatches($('c-color'), COLORS, (i) => S.color === i, (i) => { S.color = i; }, 'Color de las prendas');
    swatches($('c-marco'), FRAMES, (i) => S.frame === i, (i) => { S.frame = i; }, 'Marco');
    chips($('c-tono'), [[0, 'Rosa'], [1, 'Azul']], (v) => S.tone === v, (v) => { S.tone = v; S.color = v === 0 ? 0 : 7; });
    chips($('c-fondo'), BGS, (v) => S.bg === v, (v) => { S.bg = v; });
    const box = $('c-prendas');
    box.innerHTML = '';
    SLOTS.forEach(([slot, label]) => {
      const opts = ITEMS.filter((i) => i.s === slot && (!i.women || woman));
      if (!opts.length) return;
      const g = document.createElement('div');
      g.className = 'grupo';
      g.innerHTML = '<div class="et">' + label + '</div><div class="chips"></div>';
      box.appendChild(g);
      chips(g.querySelector('.chips'), [[null, 'Nada'], ...opts.map((i) => [i.id, i.n])], (v) => S.eq[slot] === v, (v) => { S.eq[slot] = v; });
    });
  }
  $('c-musculo').addEventListener('input', (e) => { S.lvl = +e.target.value; refresh(); render(); });
  $('c-azar').onclick = () => {
    const r = (n) => Math.floor(Math.random() * n), pick = (a) => a[r(a.length)];
    S.body = pick(BODIES)[0]; S.lvl = r(5); S.skin = r(SKINS.length); S.hair = r(HAIRS.length); S.eyeColor = r(EYES.length);
    S.eyeStyle = r(EYE_STYLES.length); S.color = r(COLORS.length); S.frame = r(FRAMES.length); S.bg = pick(BGS)[0]; S.tone = r(2);
    const woman = WOMEN.includes(S.body);
    SLOTS.forEach(([slot]) => {
      const opts = ITEMS.filter((i) => i.s === slot && (!i.women || woman));
      S.eq[slot] = r(3) === 0 ? null : pick(opts).id;
    });
    if (S.eq.traje && r(2)) S.eq.traje = null;
    refresh(); render();
  };
  $('c-guardar').onclick = () => {
    const a = document.createElement('a');
    a.download = 'mi-personaje-ritmo.png';
    a.href = canvas.toDataURL('image/png');
    a.click();
  };
  refresh();
  render();
})();
