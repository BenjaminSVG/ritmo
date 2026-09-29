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
      out[i + 3] = 0;
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
    // La ropa interior del cuerpo solo se ve si no hay nada que la cubra.
    final hideUnderwear = worn.values.any((w) => w.$1.hidesUnderwear);

    Future<ui.Image> itemImage(Item item, Equipped e) {
      final path = item.path(lvl, p.body);
      final drawn = item.recolor;
      return drawn == null
          ? load(path)
          : loadRecolored(path,
              pairMap(drawn, item.colors[e.color.clamp(0, item.colors.length - 1)]));
    }

    final bodyImg = await loadRecolored('assets/pixel/body/${p.body.id}_$lvl.png',
        {...skin, if (hideUnderwear) for (final c in underwearColors) c: transparentColor});

    final layers = <PixelLayer>[PixelLayer(bodyImg, 0, 0)];
    // Ropa sobre el cuerpo (de atrás hacia adelante): piernas, torso, traje, pies.
    for (final s in const [ItemSlot.piernas, ItemSlot.torso, ItemSlot.traje, ItemSlot.pies]) {
      if (worn[s] case (final item, final e)) layers.add(PixelLayer(await itemImage(item, e), 0, 0));
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

  static final _cuts = <String, Future<ui.Image>>{};

  /// Copia de [src] sin las filas anteriores a [row] (se vuelven transparentes).
  static Future<ui.Image> _cutTop(ui.Image src, int row, String key) => _cuts.putIfAbsent('$key|$row', () async {
        final data = await src.toByteData(format: ui.ImageByteFormat.rawRgba);
        final px = Uint8List.fromList(data!.buffer.asUint8List());
        for (var y = 0; y < row && y < src.height; y++) {
          for (var x = 0; x < src.width; x++) {
            px[(y * src.width + x) * 4 + 3] = 0;
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
