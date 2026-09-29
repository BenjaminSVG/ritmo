import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/data/db/database.dart';
import 'package:ritmo/pixel/avatar_profile.dart';
import 'package:ritmo/pixel/avatar_store.dart';
import 'package:ritmo/pixel/pixel_assets.dart';

void main() {
  toneTests();
  equipmentTests();
  group('recolor', () {
    test('sustituye colores exactos y conserva el alfa', () {
      // Dos píxeles: piel base opaca, y un píxel transparente con el mismo color.
      final px = Uint8List.fromList([0xD3, 0x9A, 0x62, 255, 0xD3, 0x9A, 0x62, 0]);
      final out = recolorRgba(px, {0xD39A62: 0x112233});
      expect(out.sublist(0, 4), [0x11, 0x22, 0x33, 255]);
      expect(out.sublist(4, 8), [0xD3, 0x9A, 0x62, 0], reason: 'transparente: no se toca');
    });

    test('no toca colores que no están en la tabla ni modifica la entrada', () {
      final px = Uint8List.fromList([0x2B, 0x23, 0x40, 255]);
      final out = recolorRgba(px, {0xD39A62: 0x112233});
      expect(out, px);
      final px2 = Uint8List.fromList([0xD3, 0x9A, 0x62, 255]);
      recolorRgba(px2, {0xD39A62: 0x112233});
      expect(px2, [0xD3, 0x9A, 0x62, 255], reason: 'la entrada original queda intacta');
    });

    test('la piel dibujada se convierte en otro tono con sus tres sombras', () {
      final m = skinMap(skinTones[7]);
      expect(m[skinDrawn.light], skinTones[7].light);
      expect(m[skinDrawn.base], skinTones[7].base);
      expect(m[skinDrawn.shadow], skinTones[7].shadow);
    });
  });

  group('paletas', () {
    test('hay 8 pieles, 24 colores de pelo (16 naturales) y 12 de ojos', () {
      expect(skinTones.length, 8);
      expect(hairColors.length, 24);
      expect(hairNaturalCount, 16);
      expect(eyeColors.length, 12);
    });

    test('los colores dibujados están en su lista (para poder volver a ellos)', () {
      expect(skinTones.contains(skinDrawn), isTrue);
      expect(hairColors.contains(hairDrawn), isTrue);
      expect(eyeColors.contains(eyeDrawn), isTrue);
    });
  });

  group('guardado del personaje', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('guarda y recupera todas las elecciones', () async {
      final store = DriftAvatarStore(db);
      expect(await store.load(), isNull);
      const p = AvatarProfile(
          name: 'Luna', body: BodyId.mujerB, skin: 6, hairColor: 17, eyeColor: 9, muscle: 3);
      await store.save(p);
      expect(await store.load(), p);
    });

    test('guardar de nuevo reemplaza la única fila', () async {
      final store = DriftAvatarStore(db);
      await store.save(const AvatarProfile(name: 'A'));
      await store.save(const AvatarProfile(name: 'B', muscle: 4));
      expect((await store.load())!.name, 'B');
      expect((await db.select(db.avatarProfiles).get()).length, 1);
    });

    test('valores fuera de rango se corrigen al cargar', () async {
      await db.into(db.avatarProfiles).insert(AvatarProfilesCompanion.insert(
          name: 'X', body: 'no_existe', skin: 99, hairColor: -5, eyeColor: 500, muscle: 9));
      final p = (await DriftAvatarStore(db).load())!;
      expect(p.body, BodyId.hombreA);
      expect(p.skin, skinTones.length - 1);
      expect(p.hairColor, 0);
      expect(p.eyeColor, eyeColors.length - 1);
      expect(p.muscle, 4);
    });
  });
}

void equipmentTests() {
  group('armario', () {
    test('se codifica y decodifica; ranuras y datos raros se ignoran', () {
      const m = {ItemSlot.sombrero: Equipped('gorra', 3), ItemSlot.cara: Equipped('anteojos')};
      expect(decodeEquipped(encodeEquipped(m)), m);
      expect(decodeEquipped('inventada:x:1,cara:anteojos:0,basura'), {ItemSlot.cara: const Equipped('anteojos')});
    });

    test('los objetos puestos se guardan con el personaje', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final store = DriftAvatarStore(db);
      const p = AvatarProfile(equipped: {ItemSlot.auriculares: Equipped('auriculares', 5)});
      await store.save(p);
      expect(await store.load(), p);
    });
  });
}

void toneTests() {
  group('tono rosa/azul', () {
    test('el rosa pasa a azul y la madera o los grises no cambian', () {
      final px = Uint8List.fromList([
        0xFF, 0x8F, 0xAB, 255, // rosa
        0x8B, 0x5A, 0x3A, 255, // madera
        0xC9, 0xC4, 0xDB, 255, // gris lila casi neutro
        0x5C, 0xC2, 0x8A, 255, // verde
      ]);
      final out = pinkToBlueRgba(px);
      expect(out[2], greaterThan(out[0]), reason: 'el rosa ahora tiene más azul que rojo');
      expect(out[2], greaterThan(out[1]));
      expect(out.sublist(4, 16), px.sublist(4, 16), reason: 'lo demás queda igual');
    });

    test('el tono viaja con el personaje y en el respaldo', () {
      const p = AvatarProfile(sceneTone: 0, equipped: {ItemSlot.fondo: Equipped('playa')});
      expect(AvatarProfileJson.fromJson(p.toJson()), p);
      expect(const AvatarProfile().sceneTone, 1, reason: 'azul por defecto');
    });
  });
}
