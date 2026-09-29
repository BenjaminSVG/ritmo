import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import 'avatar_profile.dart';
import 'catalog.dart';

/// Valor especial de una tabla de [recolorRgba]: el color se vuelve transparente.
const transparentColor = -1;

/// Colores de la ropa interior dibujada en los cuerpos base (calzoncillo gris violáceo).
/// El contorno oscuro no se toca, porque es el mismo del cuerpo.
const underwearColors = [0x8C84A8, 0x4A3F6B, 0xC9C4DB];

/// Sustituye colores EXACTOS de una imagen RGBA (0xRRGGBB → 0xRRGGBB), conservando
/// el canal alfa. Los píxeles cuyo color no está en [map] no cambian.
///
/// El arte está limpiado a una paleta fija, así que el color a sustituir coincide
/// exactamente; por eso no hace falta ninguna tolerancia.
Uint8List recolorRgba(Uint8List rgba, Map<int, int> map) {
  final out = Uint8List.fromList(rgba);
  for (var i = 0; i + 3 < out.length; i += 4) {
    if (out[i + 3] == 0) continue;
    final rgb = (out[i] << 16) | (out[i + 1] << 8) | out[i + 2];
    final to = map[rgb];
    if (to == transparentColor) {
      out[i] = out[i + 1] = out[i + 2] = out[i + 3] = 0;
    } else if (to != null) {
      out[i] = (to >> 16) & 0xFF;
      out[i + 1] = (to >> 8) & 0xFF;
      out[i + 2] = to & 0xFF;
    }
  }
  return out;
}

/// Gira los rosas y magentas (tono 290°–360°) hacia el azul (tono −130°), conservando
/// brillo y saturación. Madera, arena, verdes, cielos y azules existentes no cambian.
Uint8List pinkToBlueRgba(Uint8List rgba) {
  final out = Uint8List.fromList(rgba);
  for (var i = 0; i + 3 < out.length; i += 4) {
    if (out[i + 3] == 0) continue;
    final r = out[i] / 255, g = out[i + 1] / 255, b = out[i + 2] / 255;
    final mx = math.max(r, math.max(g, b)), mn = math.min(r, math.min(g, b));
    final d = mx - mn;
    if (d < 0.08) continue; // grises y casi blancos
    double h;
    if (mx == r) {
      h = 60 * (((g - b) / d) % 6);
    } else if (mx == g) {
      h = 60 * ((b - r) / d + 2);
    } else {
      h = 60 * ((r - g) / d + 4);
    }
    if (h < 0) h += 360;
    if (h < 290 || h > 360) continue;
    final nh = h - 130; // rosa (~340°) → azul (~210°)
    final l = (mx + mn) / 2;
    final c = d; // croma se conserva
    final x = c * (1 - ((nh / 60) % 2 - 1).abs());
    final m = l - c / 2;
    final (double rr, double gg, double bb) =
        nh < 180 ? (0, c, x) : nh < 240 ? (0, x, c) : (x, 0, c);
    out[i] = ((rr + m) * 255).round().clamp(0, 255);
    out[i + 1] = ((gg + m) * 255).round().clamp(0, 255);
    out[i + 2] = ((bb + m) * 255).round().clamp(0, 255);
  }
  return out;
}

/// Tabla de sustitución de un color dibujado (`from`) por uno elegido (`to`).
Map<int, int> pairMap(ColorPair from, ColorPair to) =>
    {from.main: to.main, from.shade: to.shade};

Map<int, int> skinMap(SkinTone to) => {
      skinDrawn.light: to.light,
      skinDrawn.base: to.base,
      skinDrawn.shadow: to.shadow,
    };

/// Una capa lista para dibujar: imagen y desplazamiento en píxeles de arte.
class PixelLayer {
  const PixelLayer(this.image, this.dx, this.dy);
  final ui.Image image;
  final int dx, dy;
}

/// El personaje resuelto: capas de atrás hacia adelante.
class ResolvedAvatar {
  const ResolvedAvatar(this.layers);
  final List<PixelLayer> layers;
}

class PixelAssets {
  PixelAssets._();

  static const canvasW = 64, canvasH = 96;
  static const sceneW = 384, sceneH = 192;

  static final _raw = <String, Future<ui.Image>>{};
  static final _recolored = <String, Future<ui.Image>>{};
  static Future<Map<String, List<(int, int)>>>? _anchors;

  static Future<ui.Image> _decode(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image> load(String path) =>
      _raw.putIfAbsent(path, () async => _decode((await rootBundle.load(path)).buffer.asUint8List()));

  /// Carga [path] y le aplica [map]. El resultado se guarda en caché por ruta y tabla.
  static Future<ui.Image> loadRecolored(String path, Map<int, int> map) {
    final key = '$path|${map.entries.map((e) => '${e.key}>${e.value}').join(',')}';
    return _recolored.putIfAbsent(key, () async {
      final src = await load(path);
      final data = await src.toByteData(format: ui.ImageByteFormat.rawRgba);
      final pixels = recolorRgba(data!.buffer.asUint8List(), map);
      final done = Completer<ui.Image>();
      ui.decodeImageFromPixels(pixels, src.width, src.height, ui.PixelFormat.rgba8888, done.complete);
      return done.future;
    });
  }

  /// Anclajes de la cabeza por cuerpo y nivel: { 'base_hombre_a': [(dx, dy) × 5], … }.
  static Future<Map<String, List<(int, int)>>> anchors() => _anchors ??= () async {
        final json = jsonDecode(await rootBundle.loadString('assets/pixel/anclajes_cabeza.json'))
            as Map<String, dynamic>;
        return json.map((k, v) => MapEntry(
            k,
            (v as List)
                .map((e) => ((e as Map)['dx'] as int, e['dy'] as int))
                .toList()));
      }();

  /// Compone el personaje: cuerpo + cabeza estándar + ojos + pelo (estos tres
  /// desplazados por el anclaje de la cabeza de ese cuerpo y nivel).
  static Future<ResolvedAvatar> resolve(AvatarProfile p) async {
    final lvl = p.muscle.clamp(0, 4);
    final skin = skinMap(skinTones[p.skin]);
    final anchor = (await anchors())['base_${p.body.id}']![lvl];

    final head = await loadRecolored('assets/pixel/head/cabeza_$lvl.png', skin);
    final eyes = await loadRecolored(
        'assets/pixel/eyes/${eyeStyles[p.eyeStyle.clamp(0, eyeStyles.length - 1)].id}_$lvl.png',
        pairMap(eyeDrawn, eyeColors[p.eyeColor]));
    final mouth = await load('assets/pixel/mouth/sonrisa_$lvl.png');
    final hair = await loadRecolored(
        'assets/pixel/hair/pelo_1_$lvl.png', pairMap(hairDrawn, hairColors[p.hairColor]));

    // Objetos puestos: uno por ranura, solo si existen en el catálogo y hay dibujo para este
    // cuerpo. Un traje tapa las ranuras de torso y piernas.
    final worn = <ItemSlot, (Item, Equipped)>{};
    for (final slot in ItemSlot.values) {
      final e = p.equipped[slot];
      final it = e == null ? null : itemById(e.id);
      if (it != null && it.slot == slot && !it.isBackground && it.fitsBody(p.body)) worn[slot] = (it, e!);
    }
    for (final w in [...worn.values]) {
      for (final s in w.$1.hidesSlots) {
        worn.remove(s);
      }
    }
    final hideHair = worn.values.any((w) => w.$1.hidesHair);

    ColorPair pairOf(Item item, Equipped e) => item.colors[e.color.clamp(0, item.colors.length - 1)];
    Future<ui.Image> itemImage(Item item, Equipped e) {
      final path = item.path(lvl, p.body);
      final drawn = item.recolor;
      return drawn == null ? load(path) : loadRecolored(path, pairMap(drawn, pairOf(item, e)));
    }

    // Ropa sobre el cuerpo (de atrás hacia adelante): piernas, torso, traje, pies.
    const clothesOrder = [ItemSlot.piernas, ItemSlot.torso, ItemSlot.traje, ItemSlot.pies];
    final rawBody = await loadRecolored('assets/pixel/body/${p.body.id}_$lvl.png', skin);
    final clothes = <ui.Image>[
      for (final s in clothesOrder)
        if (worn[s] case (final item, final e))
          if (item.fit == null)
            await itemImage(item, e)
          else
            await _fitGarment(await itemImage(item, e), rawBody, item.fit!,
                '${p.body.id}_$lvl|${item.id}|${e.color}|${p.skin}'),
    ];

    // Ropa interior del cuerpo: si una prenda la cubre, se rellena con el color de esa prenda (así no
    // queda un hueco en la entrepierna ni una franja gris). Lo de arriba (corpiño) y lo de abajo se
    // resuelven por separado según qué prenda haya.
    Map<int, int>? underMap(Item item, Equipped e) {
      final c = pairOf(item, e);
      return {0x8C84A8: c.main, 0xC9C4DB: c.main, 0x4A3F6B: c.shade};
    }

    final topWear = worn[ItemSlot.torso] ?? worn[ItemSlot.traje];
    final legWear = worn[ItemSlot.piernas] ?? worn[ItemSlot.traje];
    final bodyImg = await _dress(
      rawBody,
      top: topWear == null ? null : underMap(topWear.$1, topWear.$2),
      legs: legWear == null || !legWear.$1.hidesUnderwear ? null : underMap(legWear.$1, legWear.$2),
      garments: clothes,
      key: '${p.body.id}_$lvl|${p.skin}|${worn.entries.map((e) => '${e.key.name}:${e.value.$1.id}:${e.value.$2.color}').join(',')}',
    );

    final layers = <PixelLayer>[PixelLayer(bodyImg, 0, 0)];
    for (final img in clothes) {
      layers.add(PixelLayer(img, 0, 0));
    }
    final cut = worn.values.map((w) => w.$1.headCutRow).whereType<int>().fold<int?>(null,
        (a, b) => a == null ? b : math.max(a, b));
    layers
      ..add(PixelLayer(cut == null ? head : await _cutTop(head, cut, 'cabeza_$lvl|${p.skin}'),
          anchor.$1, anchor.$2))
      ..add(PixelLayer(eyes, anchor.$1, anchor.$2))
      ..add(PixelLayer(mouth, anchor.$1, anchor.$2));
    if (!hideHair) layers.add(PixelLayer(hair, anchor.$1, anchor.$2));
    // Objetos de la cabeza, siguiendo el anclaje de la cabeza.
    for (final s in const [ItemSlot.sombrero, ItemSlot.cara, ItemSlot.auriculares]) {
      if (worn[s] case (final item, final e)) {
        layers.add(PixelLayer(await itemImage(item, e), anchor.$1, anchor.$2 + item.dy));
      }
    }
    return ResolvedAvatar(layers);
  }

  static final _fitted = <String, Future<ui.Image>>{};

  /// Ajusta una prenda al cuerpo: borra lo que pasa más de [margin] píxeles de la silueta del cuerpo y
  /// pinta un contorno oscuro nuevo en los bordes que quedaron. Así la ropa que ChatGPT dibujó más ancha
  /// que el personaje se ve a su medida.
  static Future<ui.Image> _fitGarment(ui.Image garment, ui.Image body, int margin, String key) =>
      _fitted.putIfAbsent(key, () async {
        final w = garment.width, h = garment.height;
        final g = Uint8List.fromList((await garment.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List());
        final b = (await body.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();

        bool nearBody(int x, int y) {
          for (var dy = -margin; dy <= margin; dy++) {
            for (var dx = -margin; dx <= margin; dx++) {
              final nx = x + dx, ny = y + dy;
              if (nx >= 0 && ny >= 0 && nx < w && ny < h && b[(ny * w + nx) * 4 + 3] > 0) return true;
            }
          }
          return false;
        }

        for (var y = 0; y < h; y++) {
          for (var x = 0; x < w; x++) {
            final i = (y * w + x) * 4;
            // Se borra TODO el píxel (también su color): un píxel transparente que conserva color se
            // dibuja como un resplandor claro.
            if (g[i + 3] > 0 && !nearBody(x, y)) {
              g[i] = 0;
              g[i + 1] = 0;
              g[i + 2] = 0;
              g[i + 3] = 0;
            }
          }
        }
        // Contorno nuevo: todo píxel de la prenda que toca el vacío pasa a ser del color del contorno.
        final edge = <int>[];
        for (var y = 0; y < h; y++) {
          for (var x = 0; x < w; x++) {
            if (g[(y * w + x) * 4 + 3] == 0) continue;
            bool empty(int nx, int ny) =>
                nx < 0 || ny < 0 || nx >= w || ny >= h || g[(ny * w + nx) * 4 + 3] == 0;
            if (empty(x - 1, y) || empty(x + 1, y) || empty(x, y - 1) || empty(x, y + 1)) edge.add(y * w + x);
          }
        }
        for (final p in edge) {
          g[p * 4] = 0x2B;
          g[p * 4 + 1] = 0x23;
          g[p * 4 + 2] = 0x40;
        }
        final done = Completer<ui.Image>();
        ui.decodeImageFromPixels(g, w, h, ui.PixelFormat.rgba8888, done.complete);
        return done.future;
      });

  static final _dressed = <String, Future<ui.Image>>{};

  /// Fila (en la imagen de 64×96) que separa la ropa interior de arriba (corpiño) de la de abajo.
  static const underwearSplitRow = 52;

  /// Prepara el cuerpo para llevar ropa:
  ///  1. rellena la ropa interior de arriba ([top]) y de abajo ([legs]) con el color de la prenda;
  ///  2. pinta con el contorno oscuro los píxeles del cuerpo que quedan pegados (a 1 píxel) al borde de las
  ///     prendas, para que no asome un reborde de piel alrededor de la ropa.
  static Future<ui.Image> _dress(
    ui.Image body, {
    required Map<int, int>? top,
    required Map<int, int>? legs,
    required List<ui.Image> garments,
    required String key,
  }) {
    if (top == null && legs == null && garments.isEmpty) return Future.value(body);
    return _dressed.putIfAbsent(key, () async {
      final w = body.width, h = body.height;
      final px = Uint8List.fromList((await body.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List());

      // 1. Ropa interior → color de la prenda.
      for (var y = 0; y < h; y++) {
        final map = y < underwearSplitRow ? top : legs;
        if (map == null) continue;
        for (var x = 0; x < w; x++) {
          final i = (y * w + x) * 4;
          if (px[i + 3] == 0) continue;
          final to = map[(px[i] << 16) | (px[i + 1] << 8) | px[i + 2]];
          if (to != null) {
            px[i] = (to >> 16) & 0xFF;
            px[i + 1] = (to >> 8) & 0xFF;
            px[i + 2] = to & 0xFF;
          }
        }
      }

      // 2. Reborde: píxeles del cuerpo a 1 píxel (en cualquier dirección) de una prenda.
      if (garments.isNotEmpty) {
        final mask = Uint8List(w * h);
        for (final g in garments) {
          final gp = (await g.toByteData(format: ui.ImageByteFormat.rawRgba))!.buffer.asUint8List();
          for (var i = 0; i < w * h; i++) {
            if (gp[i * 4 + 3] > 0) mask[i] = 1;
          }
        }
        final trimmed = Uint8List.fromList(px);
        for (var y = 0; y < h; y++) {
          for (var x = 0; x < w; x++) {
            final i = (y * w + x);
            if (px[i * 4 + 3] == 0 || mask[i] == 1) continue; // lo tapado por la prenda no importa
            var near = false;
            for (var dy = -1; dy <= 1 && !near; dy++) {
              for (var dx = -1; dx <= 1; dx++) {
                final nx = x + dx, ny = y + dy;
                if (nx >= 0 && ny >= 0 && nx < w && ny < h && mask[ny * w + nx] == 1) {
                  near = true;
                  break;
                }
              }
            }
            if (near) {
              // Se vuelve contorno oscuro: la prenda queda con un borde limpio en vez de un reborde de piel.
              trimmed[i * 4] = 0x2B;
              trimmed[i * 4 + 1] = 0x23;
              trimmed[i * 4 + 2] = 0x40;
            }
          }
        }
        px.setAll(0, trimmed);
      }

      final done = Completer<ui.Image>();
      ui.decodeImageFromPixels(px, w, h, ui.PixelFormat.rgba8888, done.complete);
      return done.future;
    });
  }

  static final _cuts = <String, Future<ui.Image>>{};

  /// Copia de [src] sin las filas anteriores a [row] (se vuelven transparentes).
  static Future<ui.Image> _cutTop(ui.Image src, int row, String key) => _cuts.putIfAbsent('$key|$row', () async {
        final data = await src.toByteData(format: ui.ImageByteFormat.rawRgba);
        final px = Uint8List.fromList(data!.buffer.asUint8List());
        for (var y = 0; y < row && y < src.height; y++) {
          for (var x = 0; x < src.width; x++) {
            final i = (y * src.width + x) * 4;
            px[i] = 0;
            px[i + 1] = 0;
            px[i + 2] = 0;
            px[i + 3] = 0;
          }
        }
        final done = Completer<ui.Image>();
        ui.decodeImageFromPixels(px, src.width, src.height, ui.PixelFormat.rgba8888, done.complete);
        return done.future;
      });

  static final _bgs = <String, Future<ui.Image>>{};

  /// Fondo de la escena [id]. Con el tono azul (1) los rosas del dibujo pasan a azul.
  static Future<ui.Image> background(String id, int tone) => _bgs.putIfAbsent('$id|$tone', () async {
        final src = await load('assets/pixel/bg/$id.png');
        if (tone == 0) return src;
        final data = await src.toByteData(format: ui.ImageByteFormat.rawRgba);
        final pixels = pinkToBlueRgba(data!.buffer.asUint8List());
        final done = Completer<ui.Image>();
        ui.decodeImageFromPixels(pixels, src.width, src.height, ui.PixelFormat.rgba8888, done.complete);
        return done.future;
      });
}
