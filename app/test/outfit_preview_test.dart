// Genera una imagen de prueba con varios conjuntos sobre los cuatro cuerpos, para revisar a simple vista
// que la ropa encaja. Solo se ejecuta a pedido:
//   RITMO_PREVIEW=1 flutter test test/outfit_preview_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/pixel/avatar_profile.dart';
import 'package:ritmo/pixel/pixel_assets.dart';

void main() {
  final on = Platform.environment['RITMO_PREVIEW'] == '1';

  testWidgets('todos los ojos', skip: !on, (tester) async {
    await tester.runAsync(() async {
      const scale = 6, w = 40, h = 40;
      final rec = ui.PictureRecorder();
      final c = Canvas(rec);
      c.drawRect(Rect.fromLTWH(0, 0, (eyeStyles.length * w * scale).toDouble(), (h * scale).toDouble()),
          Paint()..color = const Color(0xFFEDEBF5));
      final paint = Paint()..filterQuality = FilterQuality.none;
      for (var k = 0; k < eyeStyles.length; k++) {
        final p = AvatarProfile(muscle: 1, autoMuscle: false, eyeStyle: k);
        for (final l in (await PixelAssets.resolve(p)).layers.skip(1)) {
          c.drawImageRect(
              l.image,
              Rect.fromLTWH(0, 0, l.image.width.toDouble(), l.image.height.toDouble()),
              Rect.fromLTWH((k * w * scale + (l.dx - 12) * scale).toDouble(), ((l.dy - 12) * scale).toDouble(),
                  (l.image.width * scale).toDouble(), (l.image.height * scale).toDouble()),
              paint);
        }
      }
      final img = await rec.endRecording().toImage(eyeStyles.length * w * scale, h * scale);
      File('../referencias/arte/limpio/prueba_ojos.png')
          .writeAsBytesSync((await img.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List());
    });
  });

  testWidgets('todos los sombreros', skip: !on, (tester) async {
    await tester.runAsync(() async {
      const scale = 5, w = 64, h = 60;
      const ids = [
        'gorra', 'gorro_lana', 'sombrero_pescador', 'cinta_deportiva', 'mono_pelo',
        'orejas_gato', 'corona_flores', 'sombrero_paja', 'sombrero_mago'
      ];
      final rec = ui.PictureRecorder();
      final c = Canvas(rec);
      c.drawRect(Rect.fromLTWH(0, 0, (ids.length * w * scale).toDouble(), (h * scale).toDouble()),
          Paint()..color = const Color(0xFFEDEBF5));
      final paint = Paint()..filterQuality = FilterQuality.none;
      for (var k = 0; k < ids.length; k++) {
        final p = AvatarProfile(
            muscle: 1, autoMuscle: false, equipped: {ItemSlot.sombrero: Equipped(ids[k], 7)});
        for (final l in (await PixelAssets.resolve(p)).layers) {
          c.drawImageRect(
              l.image,
              Rect.fromLTWH(0, 0, l.image.width.toDouble(), l.image.height.toDouble()),
              Rect.fromLTWH((k * w * scale + l.dx * scale).toDouble(), (l.dy * scale).toDouble(),
                  (l.image.width * scale).toDouble(), (l.image.height * scale).toDouble()),
              paint);
        }
      }
      final img = await rec.endRecording().toImage(ids.length * w * scale, h * scale);
      File('../referencias/arte/limpio/prueba_sombreros.png')
          .writeAsBytesSync((await img.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List());
    });
  });

  testWidgets('zoom: buzo con y sin gorro y anteojos', skip: !on, (tester) async {
    await tester.runAsync(() async {
      const scale = 6, w = 64, h = 96;
      AvatarProfile p(Map<ItemSlot, Equipped> e) =>
          AvatarProfile(muscle: 1, autoMuscle: false, equipped: e);
      const hoodie = {ItemSlot.torso: Equipped('buzo', 7), ItemSlot.piernas: Equipped('short', 7)};
      final looks = [
        p(hoodie),
        p({...hoodie, ItemSlot.sombrero: const Equipped('gorro_lana', 7)}),
        p({...hoodie, ItemSlot.cara: const Equipped('anteojos')}),
        p({...hoodie, ItemSlot.sombrero: const Equipped('sombrero_pescador', 7)}),
      ];
      final rec = ui.PictureRecorder();
      final c = Canvas(rec);
      c.drawRect(Rect.fromLTWH(0, 0, (looks.length * w * scale).toDouble(), (h * scale).toDouble()),
          Paint()..color = const Color(0xFFEDEBF5));
      final paint = Paint()..filterQuality = FilterQuality.none;
      for (var k = 0; k < looks.length; k++) {
        for (final l in (await PixelAssets.resolve(looks[k])).layers) {
          c.drawImageRect(
              l.image,
              Rect.fromLTWH(0, 0, l.image.width.toDouble(), l.image.height.toDouble()),
              Rect.fromLTWH((k * w * scale + l.dx * scale).toDouble(), (l.dy * scale).toDouble(),
                  (l.image.width * scale).toDouble(), (l.image.height * scale).toDouble()),
              paint);
        }
      }
      final img = await rec.endRecording().toImage(looks.length * w * scale, h * scale);
      File('../referencias/arte/limpio/prueba_ropa_zoom.png')
          .writeAsBytesSync((await img.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List());
    });
  });

  testWidgets('vista previa de conjuntos', skip: !on, (tester) async {
    await tester.runAsync(() async {
      const scale = 3;
      final looks = <List<AvatarProfile>>[];
      for (final body in BodyId.values) {
        final woman = body == BodyId.mujerA || body == BodyId.mujerB;
        AvatarProfile p(Map<ItemSlot, Equipped> e, int muscle) =>
            AvatarProfile(body: body, muscle: muscle, autoMuscle: false, equipped: e);
        looks.add([
          for (var m = 0; m < 5; m += 2)
            p({
              ItemSlot.torso: const Equipped('camiseta', 7),
              ItemSlot.piernas: const Equipped('pantalon', 7),
              ItemSlot.pies: const Equipped('zapatillas', 7),
              ItemSlot.sombrero: const Equipped('gorra', 7),
            }, m),
          if (woman)
            p({
              ItemSlot.traje: const Equipped('vestido', 7),
              ItemSlot.pies: const Equipped('zapatillas', 7),
              ItemSlot.sombrero: const Equipped('orejas_gato', 7),
              ItemSlot.cara: const Equipped('anteojos'),
            }, 1)
          else
            p({
              ItemSlot.torso: const Equipped('buzo', 7),
              ItemSlot.piernas: const Equipped('short', 7),
              ItemSlot.pies: const Equipped('zapatillas', 7),
              ItemSlot.sombrero: const Equipped('gorro_lana', 7),
              ItemSlot.cara: const Equipped('anteojos'),
            }, 1),
          p(const {}, 1), // desnudo, para comparar la ropa interior
        ]);
      }
      const w = 64, h = 96, gap = 6;
      final cols = looks.first.length;
      final rec = ui.PictureRecorder();
      final c = Canvas(rec);
      final totalW = cols * (w * scale + gap), totalH = looks.length * (h * scale + gap);
      c.drawRect(Rect.fromLTWH(0, 0, totalW.toDouble(), totalH.toDouble()),
          Paint()..color = const Color(0xFFEDEBF5));
      final paint = Paint()..filterQuality = FilterQuality.none;
      for (var r = 0; r < looks.length; r++) {
        for (var k = 0; k < cols; k++) {
          final av = await PixelAssets.resolve(looks[r][k]);
          for (final l in av.layers) {
            c.drawImageRect(
                l.image,
                Rect.fromLTWH(0, 0, l.image.width.toDouble(), l.image.height.toDouble()),
                Rect.fromLTWH((k * (w * scale + gap) + l.dx * scale).toDouble(),
                    (r * (h * scale + gap) + l.dy * scale).toDouble(),
                    (l.image.width * scale).toDouble(), (l.image.height * scale).toDouble()),
                paint);
          }
        }
      }
      final img = await rec.endRecording().toImage(totalW, totalH);
      final bytes = (await img.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
      File('../referencias/arte/limpio/prueba_ropa_app.png').writeAsBytesSync(bytes);
    });
  });
}
