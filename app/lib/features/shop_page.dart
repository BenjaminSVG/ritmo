import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wallet.dart';
import '../pixel/avatar_profile.dart';
import '../pixel/avatar_store.dart';
import '../pixel/catalog.dart';
import '../pixel/pixel_assets.dart';
import '../pixel/pixel_avatar.dart';

/// Tienda: se compra con monedas y nunca se pierde lo comprado.
class ShopPage extends ConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = ref.watch(walletProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tienda'), actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(child: Text('🪙 ${w.coins}', style: Theme.of(context).textTheme.titleMedium)),
        ),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), children: [
        for (final slot in ItemSlot.values) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(slot.label, style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final it in catalog.where((i) => i.slot == slot))
            _ItemTile(item: it, wallet: w),
        ],
      ]),
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item, required this.wallet});
  final Item item;
  final Wallet wallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = wallet.owned.contains(item.id);
    final canPay = wallet.coins >= item.price;
    return Card(
      // Una fila propia (no ListTile) para que la vista previa conserve su altura completa.
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          ItemThumb(item: item),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                item.bodies == null
                    ? item.rarity.label
                    : '${item.rarity.label} · Solo ${item.bodies!.map((b) => b.label).join(' y ')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]),
          ),
          const SizedBox(width: 8),
          owned
              ? const Chip(label: Text('Tuyo'), avatar: Icon(Icons.check, size: 18))
              : FilledButton(
                  onPressed: canPay
                      ? () async {
                          final ok = await ref.read(walletProvider.notifier).buy(item);
                          if (ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Compraste ${item.name}. Ya está en tu armario.')));
                          }
                        }
                      : null,
                  child: Text('🪙 ${item.price}'),
                ),
        ]),
      ),
    );
  }
}

/// Zona de la imagen del personaje (64×96) que se muestra para cada ranura: (x, y, ancho, alto).
Rect _cropFor(ItemSlot s) => switch (s) {
      ItemSlot.sombrero || ItemSlot.cara || ItemSlot.auriculares => const Rect.fromLTWH(8, 0, 48, 52),
      ItemSlot.torso => const Rect.fromLTWH(4, 36, 56, 40),
      ItemSlot.piernas => const Rect.fromLTWH(4, 52, 56, 44),
      ItemSlot.pies => const Rect.fromLTWH(8, 72, 48, 24),
      ItemSlot.traje => const Rect.fromLTWH(4, 30, 56, 66),
      ItemSlot.fondo => const Rect.fromLTWH(0, 0, 384, 192),
    };

/// Vista previa de un objeto en la tienda: el objeto puesto sobre TU personaje (con tu cuerpo,
/// piel y pelo), en el color con que se estrena; los fondos se ven completos.
class ItemThumb extends ConsumerWidget {
  const ItemThumb({super.key, required this.item});
  final Item item;

  static const _unit = 2.0; // píxeles lógicos por píxel de arte

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(effectiveAvatarProvider);
    final crop = _cropFor(item.slot);

    if (item.isBackground) {
      final bg = ref.watch(backgroundImageProvider((item.id, mine.sceneTone)));
      return _frame(
          width: 128,
          height: 64,
          child: bg.hasValue
              ? RawImage(image: bg.requireValue, fit: BoxFit.cover, filterQuality: FilterQuality.medium)
              : const SizedBox());
    }

    // El objeto solo, sobre el personaje del usuario, sin nada más puesto; si el objeto no existe
    // para su cuerpo, se muestra en el primer cuerpo para el que sí existe.
    final body = item.fitsBody(mine.body) ? mine.body : item.bodies!.first;
    final preview = mine.copyWith(
      body: body,
      autoMuscle: false,
      equipped: {item.slot: Equipped(item.id, item.defaultColorFor(mine.sceneTone))},
    );
    final avatar = ref.watch(resolvedAvatarProvider(preview));
    return _frame(
      width: crop.width * _unit,
      height: crop.height * _unit,
      child: avatar.hasValue
          ? CustomPaint(painter: _ThumbPainter(avatar.requireValue, crop, _unit))
          : const SizedBox(),
    );
  }

  Widget _frame({required double width, required double height, required Widget child}) => Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFE9ECFB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
}

class _ThumbPainter extends CustomPainter {
  _ThumbPainter(this.avatar, this.crop, this.unit);
  final ResolvedAvatar avatar;
  final Rect crop;
  final double unit;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..filterQuality = FilterQuality.none
      ..isAntiAlias = false;
    canvas.clipRect(Offset.zero & size);
    for (final l in avatar.layers) {
      canvas.drawImageRect(
          l.image,
          Rect.fromLTWH(0, 0, l.image.width.toDouble(), l.image.height.toDouble()),
          Rect.fromLTWH((l.dx - crop.left) * unit, (l.dy - crop.top) * unit,
              l.image.width * unit, l.image.height * unit),
          paint);
    }
  }

  @override
  bool shouldRepaint(_ThumbPainter o) => o.avatar != avatar || o.crop != crop;
}
