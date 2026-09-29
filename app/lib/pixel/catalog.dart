import 'avatar_profile.dart';

/// Rareza y precio base en monedas (doc 09, §9.6).
enum Rarity {
  gratis('Gratis', 0),
  comun('Común', 90),
  raro('Raro', 400),
  epico('Épico', 1300);

  const Rarity(this.label, this.price);
  final String label;
  final int price;
}

/// Un objeto que se puede llevar puesto. El `id` es estable y parte del nombre del arte.
class Item {
  const Item(this.id, this.name, this.slot, this.rarity,
      {this.recolor,
      this.palette,
      this.hidesHair = false,
      this.hidesUnderwear = false,
      this.hidesSlots = const [],
      this.bodies,
      this.fit,
      this.dy = 0,
      this.headCutRow});

  /// Si no es null, la prenda se recorta para no pasar más de [fit] píxeles de la silueta del cuerpo (y
  /// se le dibuja un contorno nuevo). Sirve para ropa que ChatGPT dibujó más ancha que el cuerpo. Las
  /// prendas con vuelo (polleras, vestidos) no se ajustan.
  final int? fit;

  /// Si no es null, las filas de la cabeza por encima de esta (en coordenadas de la imagen de la cabeza)
  /// no se dibujan: sirve para sombreros cuya copa es más angosta que la cabeza (el de mago), para que
  /// la cabeza no asome por los lados.
  final int? headCutRow;

  /// Ajuste vertical en píxeles de arte (negativo = sube), para dibujos que ChatGPT
  /// hizo demasiado grandes o bajos, como el gorro de lana.
  final int dy;

  /// Si es true, la ropa interior del cuerpo no se dibuja (pantalones, shorts, polleras, vestidos).
  final bool hidesUnderwear;

  /// Ranuras que quedan tapadas mientras esté puesto (un vestido tapa torso y piernas).
  final List<ItemSlot> hidesSlots;

  /// Cuerpos para los que existe el dibujo; null = todos.
  final List<BodyId>? bodies;

  bool fitsBody(BodyId b) => bodies == null || bodies!.contains(b);

  /// La ropa se dibuja aparte para cada cuerpo (recorte y proporciones distintas).
  bool get perBody => const [ItemSlot.torso, ItemSlot.piernas, ItemSlot.pies, ItemSlot.traje].contains(slot);

  final Rarity rarity;

  /// Precio en monedas, según la rareza (doc 11, §11.7).
  int get price => rarity.price;
  final String id, name;
  final ItemSlot slot;

  /// Colores con los que está dibujado el objeto; null = no se puede teñir.
  final ColorPair? recolor;

  /// Colores para teñirlo; null = [itemColors].
  final List<ColorPair>? palette;
  List<ColorPair> get colors => palette ?? itemColors;

  /// Si es true, el pelo no se dibuja mientras esté puesto (gorras, gorros…).
  final bool hidesHair;

  bool get isBackground => slot == ItemSlot.fondo;

  /// Índice de color con el que se estrena según el tono elegido (0 rosa, 1 azul).
  /// Los objetos con marco (anteojos) empiezan con el primer color del marco.
  int defaultColorFor(int sceneTone) =>
      palette != null ? 0 : (sceneTone == 0 ? 0 : itemBlueIndex);

  String path(int muscleLevel, [BodyId body = BodyId.hombreA]) => isBackground
      ? 'assets/pixel/bg/$id.png'
      : perBody
          ? 'assets/pixel/items/$id/${body.id}_$muscleLevel.png'
          : 'assets/pixel/items/$id/${id}_$muscleLevel.png';
}

/// Rosa con el que está dibujada la ropa; se sustituye por el color elegido.
const itemDrawn = ColorPair('Rosa', 0xFF8FAB, 0xD65A7E);

/// Posición del Azul en [itemColors]. Los dibujos están hechos en rosa (posición 0).
const itemBlueIndex = 7;

/// Colores disponibles para teñir objetos.
const itemColors = [
  itemDrawn,
  ColorPair('Rojo', 0xE8505B, 0xB13E53),
  ColorPair('Naranja', 0xFFAA6B, 0xD9782F),
  ColorPair('Amarillo', 0xFFD866, 0xE0A83A),
  ColorPair('Verde', 0x5CC28A, 0x2F8F6B),
  ColorPair('Turquesa', 0x6ED3D0, 0x3AA5A8),
  ColorPair('Celeste', 0x7EC8F5, 0x4F6AF5),
  ColorPair('Azul', 0x4F6AF5, 0x3446B8),
  ColorPair('Lila', 0xB69CF2, 0x7C5FCF),
  ColorPair('Blanco', 0xF4F0F8, 0xC9C4DB),
  ColorPair('Gris', 0x8C84A8, 0x4A3F6B),
  ColorPair('Negro', 0x4A3F6B, 0x2B2340),
];

/// Catálogo de objetos. Los identificadores nunca se reutilizan ni cambian.
const catalog = [
  // Sombrero (los que tapan el pelo llevan hidesHair)
  Item('gorra', 'Gorra', ItemSlot.sombrero, Rarity.comun, recolor: itemDrawn, hidesHair: true),
  Item('gorro_lana', 'Gorro de lana', ItemSlot.sombrero, Rarity.comun,
      recolor: itemDrawn, hidesHair: true, dy: -8),
  Item('sombrero_pescador', 'Sombrero de pescador', ItemSlot.sombrero, Rarity.comun,
      recolor: itemDrawn, hidesHair: true),
  Item('cinta_deportiva', 'Cinta deportiva', ItemSlot.sombrero, Rarity.comun, recolor: itemDrawn),
  Item('mono_pelo', 'Moño', ItemSlot.sombrero, Rarity.comun, recolor: itemDrawn),
  Item('orejas_gato', 'Orejas de gato', ItemSlot.sombrero, Rarity.raro, recolor: itemDrawn),
  Item('corona_flores', 'Corona de flores', ItemSlot.sombrero, Rarity.raro, recolor: itemDrawn),
  Item('sombrero_paja', 'Sombrero de paja', ItemSlot.sombrero, Rarity.raro,
      recolor: itemDrawn, hidesHair: true, dy: -4),
  Item('sombrero_mago', 'Sombrero de mago', ItemSlot.sombrero, Rarity.epico,
      recolor: itemDrawn, hidesHair: true, dy: -5, headCutRow: 30),
  // Cara
  Item('anteojos', 'Anteojos redondos', ItemSlot.cara, Rarity.gratis,
      recolor: frameDrawn, palette: frameColors),
  Item('anteojos_cuadrados', 'Anteojos cuadrados', ItemSlot.cara, Rarity.comun,
      recolor: frameDrawn, palette: frameColors),
  Item('anteojos_ojo_gato', 'Anteojos ojo de gato', ItemSlot.cara, Rarity.comun,
      recolor: frameDrawn, palette: frameColors),
  Item('anteojos_hexagonales', 'Anteojos hexagonales', ItemSlot.cara, Rarity.comun,
      recolor: frameDrawn, palette: frameColors),
  Item('anteojos_medio_marco', 'Anteojos de medio marco', ItemSlot.cara, Rarity.comun,
      recolor: frameDrawn, palette: frameColors),
  // Torso
  Item('camiseta', 'Camiseta', ItemSlot.torso, Rarity.comun, recolor: itemDrawn, fit: 1),
  Item('buzo', 'Buzo con capucha', ItemSlot.torso, Rarity.raro, recolor: itemDrawn, fit: 2),
  // Piernas
  Item('pantalon', 'Pantalón', ItemSlot.piernas, Rarity.comun,
      recolor: itemDrawn, hidesUnderwear: true, fit: 1),
  Item('short', 'Short deportivo', ItemSlot.piernas, Rarity.comun,
      recolor: itemDrawn, hidesUnderwear: true, fit: 1),
  Item('pollera', 'Pollera', ItemSlot.piernas, Rarity.comun,
      recolor: itemDrawn, hidesUnderwear: true, bodies: _women),
  // Pies
  Item('zapatillas', 'Zapatillas', ItemSlot.pies, Rarity.comun, recolor: itemDrawn, fit: 1),
  // Traje: cuerpo completo
  Item('vestido', 'Vestido de verano', ItemSlot.traje, Rarity.raro,
      recolor: itemDrawn,
      hidesUnderwear: true,
      hidesSlots: [ItemSlot.torso, ItemSlot.piernas],
      bodies: _women),
  // Auriculares
  Item('auriculares', 'Auriculares', ItemSlot.auriculares, Rarity.raro, recolor: itemDrawn),
  // Fondos de la escena (imagen completa en assets/pixel/bg/)
  Item('dormitorio', 'Dormitorio', ItemSlot.fondo, Rarity.gratis),
  Item('parque', 'Parque', ItemSlot.fondo, Rarity.gratis),
  Item('gimnasio', 'Gimnasio', ItemSlot.fondo, Rarity.comun),
  Item('cocina', 'Cocina', ItemSlot.fondo, Rarity.comun),
  Item('biblioteca', 'Biblioteca', ItemSlot.fondo, Rarity.comun),
  Item('cafe', 'Café', ItemSlot.fondo, Rarity.comun),
  Item('playa', 'Playa', ItemSlot.fondo, Rarity.raro),
  Item('bosque', 'Bosque mágico', ItemSlot.fondo, Rarity.raro),
  Item('azotea', 'Azotea de noche', ItemSlot.fondo, Rarity.raro),
  Item('jardin', 'Jardín japonés', ItemSlot.fondo, Rarity.raro),
  Item('cabana', 'Cabaña con nieve', ItemSlot.fondo, Rarity.raro),
  Item('estacion', 'Estación espacial', ItemSlot.fondo, Rarity.epico),
  Item('oasis', 'Oasis en el desierto', ItemSlot.fondo, Rarity.epico),
];

const _women = [BodyId.mujerA, BodyId.mujerB];

/// Fondo con el que se empieza.
const defaultBackground = 'dormitorio';

Item? itemById(String id) {
  for (final i in catalog) {
    if (i.id == id) return i;
  }
  return null;
}

/// Color del marco con el que están dibujados los anteojos (el mismo violeta oscuro del contorno).
const frameDrawn = ColorPair('Marco', 0x2B2340, 0x2B2340);

/// Colores de marco para anteojos: claros y variados; el primero es el de por defecto.
const frameColors = [
  ColorPair('Plateado', 0xB8B4C4, 0xB8B4C4),
  ColorPair('Dorado', 0xE0B070, 0xE0B070),
  ColorPair('Marrón', 0x8B5A3A, 0x8B5A3A),
  ColorPair('Rosa', 0xFF8FAB, 0xFF8FAB),
  ColorPair('Celeste', 0x7EC8F5, 0x7EC8F5),
  ColorPair('Verde', 0x5CC28A, 0x5CC28A),
  ColorPair('Lila', 0xB69CF2, 0xB69CF2),
  ColorPair('Rojo', 0xE8505B, 0xE8505B),
  ColorPair('Blanco', 0xF4F0F8, 0xF4F0F8),
  ColorPair('Negro', 0x2B2340, 0x2B2340),
];
