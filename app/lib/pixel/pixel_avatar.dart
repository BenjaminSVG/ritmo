import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'avatar_profile.dart';
import 'catalog.dart';
import 'pixel_assets.dart';

final resolvedAvatarProvider = FutureProvider.family<ResolvedAvatar, AvatarProfile>(
    (ref, profile) => PixelAssets.resolve(profile));

/// Fondo de la escena por (id, tono).
final backgroundImageProvider = FutureProvider.family<ui.Image, (String, int)>(
    (ref, key) => PixelAssets.background(key.$1, key.$2));

/// Escena pixel art: fondo 384×192 con el personaje 64×96 de pie, con un leve balanceo.
///
/// Se escala a un **número entero de píxeles del dispositivo** por cada píxel de arte,
/// para que los píxeles se vean nítidos y del mismo tamaño (nada de bordes borrosos).
class PixelScene extends ConsumerStatefulWidget {
  const PixelScene({super.key, required this.profile});
  final AvatarProfile profile;

  @override
  ConsumerState<PixelScene> createState() => _PixelSceneState();
}

class _PixelSceneState extends ConsumerState<PixelScene> with SingleTickerProviderStateMixin {
  late final AnimationController _bob =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = ref.watch(resolvedAvatarProvider(widget.profile));
    final bg = ref.watch(backgroundImageProvider(
        (widget.profile.equipped[ItemSlot.fondo]?.id ?? defaultBackground, widget.profile.sceneTone)));
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return LayoutBuilder(builder: (context, box) {
      // Píxeles físicos por píxel de arte (entero, mínimo 1).
      final s = ((box.maxWidth * dpr) / PixelAssets.sceneW).floor().clamp(1, 16);
      // El personaje usa píxeles ~1,5 veces más grandes que los del fondo (también enteros).
      final cs = (s * 1.5).floor() > s ? (s * 1.5).floor() : s + 1;
      final w = PixelAssets.sceneW * s / dpr;
      final h = PixelAssets.sceneH * s / dpr;
      return Center(
        child: SizedBox(
          width: w,
          height: h,
          child: (avatar.hasValue && bg.hasValue)
              ? AnimatedBuilder(
                  animation: _bob,
                  builder: (_, _) => CustomPaint(
                    painter: _ScenePainter(
                      bg: bg.requireValue,
                      avatar: avatar.requireValue,
                      unit: s / dpr,
                      charUnit: cs / dpr,
                      // Sube 1 píxel de arte en la segunda mitad del ciclo.
                      bobUp: _bob.value > 0.5 ? 1 : 0,
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      );
    });
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({required this.bg, required this.avatar, required this.unit, required this.charUnit, required this.bobUp});
  final ui.Image bg;
  final ResolvedAvatar avatar;

  /// Tamaño lógico de un píxel de arte.
  final double unit;

  /// Tamaño lógico de un píxel de arte del personaje (mayor que [unit]).
  final double charUnit;
  final int bobUp;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..filterQuality = FilterQuality.none
      ..isAntiAlias = false;

    Rect dst(int x, int y, int w, int h) => Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit);
    void draw(ui.Image img, int x, int y) => canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        dst(x, y, img.width, img.height),
        paint);

    draw(bg, 0, 0);
    // Centrado, con los pies a 16 px (del fondo) del borde inferior de la escena.
    final x0 = (PixelAssets.sceneW * unit - PixelAssets.canvasW * charUnit) / 2;
    final y0 = (PixelAssets.sceneH - 16) * unit - (PixelAssets.canvasH + bobUp) * charUnit;
    for (final l in avatar.layers) {
      final img = l.image;
      canvas.drawImageRect(
          img,
          Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
          Rect.fromLTWH(x0 + l.dx * charUnit, y0 + l.dy * charUnit, img.width * charUnit,
              img.height * charUnit),
          paint);
    }
  }

  @override
  bool shouldRepaint(_ScenePainter o) =>
      o.bg != bg || o.avatar != avatar || o.unit != unit || o.charUnit != charUnit || o.bobUp != bobUp;
}

/// La escena fija (sin animación ni carga), lista para dibujarla fuera de pantalla: la usa el widget
/// de la pantalla de inicio. [scale] es el tamaño en píxeles lógicos de un píxel del fondo.
class SceneSnapshot extends StatelessWidget {
  const SceneSnapshot({super.key, required this.bg, required this.avatar, this.scale = 3});
  final ui.Image bg;
  final ResolvedAvatar avatar;
  final int scale;

  static int charScale(int s) => (s * 1.5).floor() > s ? (s * 1.5).floor() : s + 1;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(PixelAssets.sceneW * scale.toDouble(), PixelAssets.sceneH * scale.toDouble()),
        painter: _ScenePainter(
            bg: bg,
            avatar: avatar,
            unit: scale.toDouble(),
            charUnit: charScale(scale).toDouble(),
            bobUp: 0),
      );
}
