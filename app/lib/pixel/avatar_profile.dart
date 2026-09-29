/// Cuerpos disponibles. El `id` es parte del nombre de los archivos de arte.
enum BodyId {
  hombreA('hombre_a', 'Hombre A'),
  hombreB('hombre_b', 'Hombre B'),
  mujerA('mujer_a', 'Mujer A'),
  mujerB('mujer_b', 'Mujer B');

  const BodyId(this.id, this.label);
  final String id;
  final String label;
}

/// Ranuras de la cabeza (se irán sumando torso, piernas, pies…). El orden es el de dibujo.
enum ItemSlot {
  sombrero('Sombrero'),
  cara('Cara'),
  auriculares('Auriculares'),
  torso('Torso'),
  piernas('Piernas'),
  pies('Pies'),
  traje('Traje (cuerpo completo)'),

  /// No es una capa del personaje: es el fondo de la escena (va siempre al final).
  fondo('Fondo');

  const ItemSlot(this.label);
  final String label;
}

/// Un objeto puesto: su id del catálogo y el índice de color en `itemColors`.
class Equipped {
  const Equipped(this.id, [this.color = 0]);
  final String id;
  final int color;

  @override
  bool operator ==(Object other) => other is Equipped && other.id == id && other.color == color;
  @override
  int get hashCode => Object.hash(id, color);
}

/// Guardado como "ranura:id:color,ranura:id:color".
String encodeEquipped(Map<ItemSlot, Equipped> m) =>
    (m.entries.toList()..sort((a, b) => a.key.index.compareTo(b.key.index)))
        .map((e) => '${e.key.name}:${e.value.id}:${e.value.color}')
        .join(',');

Map<ItemSlot, Equipped> decodeEquipped(String s) {
  final out = <ItemSlot, Equipped>{};
  for (final part in s.split(',')) {
    final p = part.split(':');
    if (p.length != 3) continue;
    final slot = ItemSlot.values.asNameMap()[p[0]];
    if (slot != null && p[1].isNotEmpty) out[slot] = Equipped(p[1], int.tryParse(p[2]) ?? 0);
  }
  return out;
}

/// Forma de los ojos (con sus cejas). El `id` es parte del nombre del arte; el orden es estable.
class EyeStyle {
  const EyeStyle(this.id, this.label);
  final String id, label;
}

const eyeStyles = [
  EyeStyle('clasicos', 'Clásicos'),
  EyeStyle('grandes', 'Grandes'),
  EyeStyle('dulces', 'Dulces'),
  EyeStyle('brillantes', 'Brillantes'),
  EyeStyle('almendrados', 'Almendrados'),
  EyeStyle('sonolientos', 'Soñolientos'),
  EyeStyle('felices', 'Felices'),
  EyeStyle('decididos', 'Decididos'),
  EyeStyle('puntitos', 'Puntitos'),
];

/// Nombres de los 5 niveles de musculatura.
const muscleNames = ['Principiante', 'Activo', 'Atlético', 'Fuerte', 'Legendario'];

/// Tono de piel con sus tres tonos (luz, base y sombra), como 0xRRGGBB.
class SkinTone {
  const SkinTone(this.name, this.light, this.base, this.shadow);
  final String name;
  final int light, base, shadow;
}

/// Un color con su tono principal y su sombra (pelo, ojos), como 0xRRGGBB.
class ColorPair {
  const ColorPair(this.name, this.main, this.shade);
  final String name;
  final int main, shade;
}

/// Colores con los que está DIBUJADO el arte; se sustituyen por los elegidos.
/// El arte usa el tono de piel 4 (Dorado), el pelo marrón y el iris azul.
const skinDrawn = SkinTone('Dorado', 0xE8B77F, 0xD39A62, 0xA87445);
const hairDrawn = ColorPair('Castaño', 0xA9714B, 0x6E4530);
const eyeDrawn = ColorPair('Azul', 0x4F6AF5, 0x3446B8);

const skinTones = [
  SkinTone('Marfil', 0xFFE3CF, 0xF6CDB1, 0xD9A585),
  SkinTone('Claro', 0xFBD5B5, 0xEDB98F, 0xC98F68),
  SkinTone('Beige', 0xF2C79C, 0xE2AA7B, 0xB98058),
  skinDrawn,
  SkinTone('Canela', 0xD39A6A, 0xB87B4D, 0x8F5B36),
  SkinTone('Caramelo', 0xB87B50, 0x9A6035, 0x744423),
  SkinTone('Moreno', 0x8D5A3B, 0x734529, 0x54301C),
  SkinTone('Ébano', 0x6A4030, 0x52301F, 0x3A2015),
];

/// 16 colores naturales y 8 de fantasía (los últimos 8).
const hairColors = [
  ColorPair('Negro', 0x3A3446, 0x2B2340),
  ColorPair('Chocolate', 0x5A3A2A, 0x3B2318),
  ColorPair('Castaño oscuro', 0x6E4530, 0x4A2E20),
  hairDrawn,
  ColorPair('Castaño claro', 0xC58B5C, 0x8F5F3D),
  ColorPair('Miel', 0xE0B070, 0xB0803F),
  ColorPair('Rubio oscuro', 0xD2A85C, 0xA67C3A),
  ColorPair('Rubio', 0xF2D27A, 0xC9A34A),
  ColorPair('Rubio platino', 0xF7E8A8, 0xD8C070),
  ColorPair('Pelirrojo', 0xD9642B, 0xA2401A),
  ColorPair('Cobrizo', 0xB5532F, 0x7F3319),
  ColorPair('Caoba', 0x7A3B34, 0x4F2422),
  ColorPair('Rojizo', 0x8C4A32, 0x5E2F1E),
  ColorPair('Negro azulado', 0x3B4468, 0x262C47),
  ColorPair('Gris', 0xB8B4C4, 0x8C84A8),
  ColorPair('Blanco', 0xF4F0F8, 0xC9C4DB),
  // Fantasía
  ColorPair('Rosa', 0xFF8FAB, 0xD65A7E),
  ColorPair('Celeste', 0x7EC8F5, 0x4F6AF5),
  ColorPair('Verde', 0x5CC28A, 0x2F8F6B),
  ColorPair('Lila', 0xB69CF2, 0x7C5FCF),
  ColorPair('Turquesa', 0x6ED3D0, 0x3AA5A8),
  ColorPair('Naranja', 0xFFAA6B, 0xD9782F),
  ColorPair('Cereza', 0xF0686A, 0xB13E53),
  ColorPair('Amarillo', 0xFFD866, 0xE0A83A),
];
const hairNaturalCount = 16;

const eyeColors = [
  eyeDrawn,
  ColorPair('Celeste', 0x7EC8F5, 0x4F9FD8),
  ColorPair('Verde', 0x5CC28A, 0x2F8F6B),
  ColorPair('Avellana', 0xA9814B, 0x6E5030),
  ColorPair('Marrón', 0x8B5A3A, 0x5E3B24),
  ColorPair('Marrón oscuro', 0x5A3A2A, 0x3B2318),
  ColorPair('Gris', 0x94A0B8, 0x66728C),
  ColorPair('Violeta', 0xB69CF2, 0x7C5FCF),
  ColorPair('Ámbar', 0xF0A83C, 0xC97A1E),
  ColorPair('Rosa', 0xFF8FAB, 0xD65A7E),
  ColorPair('Turquesa', 0x6ED3D0, 0x3AA5A8),
  ColorPair('Negro', 0x4A3F6B, 0x2B2340),
];

/// El personaje elegido por el usuario.
class AvatarProfile {
  const AvatarProfile({
    this.name = 'Ritmo',
    this.body = BodyId.hombreA,
    this.skin = 3,
    this.hairColor = 3,
    this.eyeColor = 0,
    this.muscle = 0,
    this.autoMuscle = true,
    this.equipped = const {},
    this.sceneTone = 1,
    this.eyeStyle = 0,
  });

  /// Índice en [eyeStyles].
  final int eyeStyle;

  /// Tono de la escena y de los colores con que se estrenan los objetos: 0 rosa, 1 azul.
  final int sceneTone;

  /// Objetos puestos, uno por ranura.
  final Map<ItemSlot, Equipped> equipped;

  final String name;
  final BodyId body;

  /// Índices en [skinTones], [hairColors] y [eyeColors].
  final int skin, hairColor, eyeColor;

  /// Nivel de musculatura 0–4.
  final int muscle;

  /// Si es true, la musculatura sale de los hábitos de ejercicio y [muscle] se ignora.
  final bool autoMuscle;

  AvatarProfile copyWith({
    String? name,
    BodyId? body,
    int? skin,
    int? hairColor,
    int? eyeColor,
    int? muscle,
    bool? autoMuscle,
    Map<ItemSlot, Equipped>? equipped,
    int? sceneTone,
    int? eyeStyle,
  }) =>
      AvatarProfile(
        name: name ?? this.name,
        body: body ?? this.body,
        skin: skin ?? this.skin,
        hairColor: hairColor ?? this.hairColor,
        eyeColor: eyeColor ?? this.eyeColor,
        muscle: muscle ?? this.muscle,
        autoMuscle: autoMuscle ?? this.autoMuscle,
        equipped: equipped ?? this.equipped,
        sceneTone: sceneTone ?? this.sceneTone,
        eyeStyle: eyeStyle ?? this.eyeStyle,
      );

  @override
  bool operator ==(Object other) =>
      other is AvatarProfile &&
      other.name == name &&
      other.body == body &&
      other.skin == skin &&
      other.hairColor == hairColor &&
      other.eyeColor == eyeColor &&
      other.muscle == muscle &&
      other.autoMuscle == autoMuscle &&
      other.sceneTone == sceneTone &&
      other.eyeStyle == eyeStyle &&
      encodeEquipped(other.equipped) == encodeEquipped(equipped);

  @override
  int get hashCode => Object.hash(name, body, skin, hairColor, eyeColor, muscle, autoMuscle, sceneTone, eyeStyle, encodeEquipped(equipped));
}

extension AvatarProfileJson on AvatarProfile {
  Map<String, dynamic> toJson() => {
        'name': name,
        'body': body.id,
        'skin': skin,
        'hairColor': hairColor,
        'eyeColor': eyeColor,
        'muscle': muscle,
        'autoMuscle': autoMuscle,
        'equipped': encodeEquipped(equipped),
        'sceneTone': sceneTone,
        'eyeStyle': eyeStyle,
      };

  /// Valores fuera de rango se corrigen; un objeto desconocido se ignora al dibujar.
  static AvatarProfile fromJson(Map<String, dynamic> j) {
    int fit(Object? v, int len) => ((v as int?) ?? 0).clamp(0, len - 1);
    return AvatarProfile(
      name: (j['name'] as String?)?.trim().isNotEmpty == true ? j['name'] as String : 'Ritmo',
      body: BodyId.values.firstWhere((b) => b.id == j['body'], orElse: () => BodyId.hombreA),
      skin: fit(j['skin'], skinTones.length),
      hairColor: fit(j['hairColor'], hairColors.length),
      eyeColor: fit(j['eyeColor'], eyeColors.length),
      muscle: fit(j['muscle'], muscleNames.length),
      autoMuscle: j['autoMuscle'] as bool? ?? true,
      equipped: decodeEquipped(j['equipped'] as String? ?? ''),
      sceneTone: fit(j['sceneTone'] ?? 1, 2),
      eyeStyle: fit(j['eyeStyle'] ?? 0, eyeStyles.length),
    );
  }
}
