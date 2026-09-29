import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wallet.dart';
import '../domain/muscle.dart';
import '../pixel/avatar_profile.dart';
import '../pixel/catalog.dart';
import 'shop_page.dart';
import '../pixel/avatar_store.dart';
import '../pixel/pixel_avatar.dart';

/// Pantalla del personaje: la escena y los controles para elegir cuerpo, piel,
/// pelo, ojos y musculatura. Los cambios se guardan solos.
class CharacterPage extends ConsumerWidget {
  const CharacterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(effectiveAvatarProvider);
    final exDays = ref.watch(exerciseDaysProvider);
    final n = ref.read(avatarProvider.notifier);
    final title = Theme.of(context).textTheme.titleMedium;

    Widget swatch(int color, bool selected, VoidCallback onTap, {String? tip}) => GestureDetector(
          onTap: onTap,
          child: Tooltip(
            message: tip ?? '',
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Color(0xFF000000 | color),
                shape: BoxShape.circle,
                border: Border.all(
                    width: selected ? 3 : 1,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
          ),
        );

    return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
      PixelScene(profile: p),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: _Wardrobe(
          profile: p,
          owned: ref.watch(walletProvider).owned,
          onChange: (e) => n.update((a) => a.copyWith(equipped: e)),
          onTone: (t) => n.update((a) => a.copyWith(sceneTone: t)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: _WalletBar(wallet: ref.watch(walletProvider)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
            key: ValueKey(p.name),
            initialValue: p.name,
            maxLength: 20,
            decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
            onFieldSubmitted: (v) {
              final t = v.trim();
              if (t.isNotEmpty) n.update((a) => a.copyWith(name: t));
            },
          ),
          const SizedBox(height: 8),
          Text('Cuerpo', style: title),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final b in BodyId.values)
              ChoiceChip(
                label: Text(b.label),
                selected: p.body == b,
                onSelected: (_) => n.update((a) => a.copyWith(body: b)),
              ),
          ]),
          const SizedBox(height: 16),
          Text('Musculatura: ${muscleNames[p.muscle]}', style: title),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Automática con mis hábitos de ejercicio'),
            value: p.autoMuscle,
            // Al pasar a manual se parte del nivel que se veía.
            onChanged: (v) => n.update((a) => a.copyWith(autoMuscle: v, muscle: p.muscle)),
          ),
          if (p.autoMuscle)
            Text(
              'Llevas $exDays de los últimos $muscleWindowDays días con ejercicio. '
              'Marca un hábito como "Ejercicio" al editarlo. Sube con la constancia y baja '
              'muy despacio si lo dejas; nunca hay castigo.',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Slider(
              value: p.muscle.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              label: muscleNames[p.muscle],
              onChanged: (v) => n.update((a) => a.copyWith(muscle: v.round())),
            ),
          const SizedBox(height: 16),
          Text('Piel', style: title),
          const SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (var i = 0; i < skinTones.length; i++)
              swatch(skinTones[i].base, p.skin == i, () => n.update((a) => a.copyWith(skin: i)),
                  tip: skinTones[i].name),
          ]),
          const SizedBox(height: 16),
          Text('Pelo', style: title),
          const SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (var i = 0; i < hairColors.length; i++)
              swatch(hairColors[i].main, p.hairColor == i,
                  () => n.update((a) => a.copyWith(hairColor: i)),
                  tip: hairColors[i].name),
          ]),
          const SizedBox(height: 16),
          Text('Ojos', style: title),
          const SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (var i = 0; i < eyeColors.length; i++)
              swatch(eyeColors[i].main, p.eyeColor == i,
                  () => n.update((a) => a.copyWith(eyeColor: i)),
                  tip: eyeColors[i].name),
          ]),
          const SizedBox(height: 12),
          Text('Forma de los ojos', style: title),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var i = 0; i < eyeStyles.length; i++)
              ChoiceChip(
                label: Text(eyeStyles[i].label),
                selected: p.eyeStyle == i,
                onSelected: (_) => n.update((a) => a.copyWith(eyeStyle: i)),
              ),
          ]),
        ]),
      ),
    ]);
  }
}

/// Monedas, estrellas, nivel y lo ganado hoy.
class _WalletBar extends StatelessWidget {
  const _WalletBar({required this.wallet});
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final lv = wallet.level;
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('🪙 ${wallet.coins}', style: t.titleLarge),
            const SizedBox(width: 16),
            Text('⭐ ${wallet.stars}', style: t.titleLarge),
            const Spacer(),
            Text('Nivel ${lv.level}', style: t.titleMedium),
          ]),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: lv.into / lv.needed),
          const SizedBox(height: 4),
          Text('Hoy: +${wallet.todayCoins} 🪙 · ${lv.into}/${lv.needed} XP para el siguiente nivel',
              style: t.bodySmall),
        ]),
      ),
    );
  }
}

/// Armario: por ranura, elegir un objeto comprado (o nada) y su color.
class _Wardrobe extends StatelessWidget {
  const _Wardrobe(
      {required this.profile, required this.owned, required this.onChange, required this.onTone});
  final AvatarProfile profile;
  final Set<String> owned;
  final void Function(Map<ItemSlot, Equipped>) onChange;
  final void Function(int) onTone;

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.titleMedium;
    void set(ItemSlot s, Equipped? e) {
      final m = {...profile.equipped};
      e == null ? m.remove(s) : m[s] = e;
      onChange(m);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('Armario', style: title),
            const Spacer(),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.storefront_outlined),
              label: const Text('Tienda'),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => const ShopPage())),
            ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Text('Tono', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(width: 12),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 0, label: Text('Rosa')),
                ButtonSegment(value: 1, label: Text('Azul')),
              ],
              selected: {profile.sceneTone},
              onSelectionChanged: (s) => onTone(s.first),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Cambia el color de la escena y con qué color se estrenan tus prendas.',
                style: Theme.of(context).textTheme.bodySmall),
          ),
          for (final slot in ItemSlot.values.where((s) => catalog.any((i) =>
              i.slot == s && owned.contains(i.id) && i.fitsBody(profile.body)))) ...[
            const SizedBox(height: 10),
            Text(slot.label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 8, children: [
              // El fondo siempre tiene uno puesto (empieza con el dormitorio), sin "Nada".
              if (slot != ItemSlot.fondo)
                ChoiceChip(
                  label: const Text('Nada'),
                  selected: profile.equipped[slot] == null,
                  onSelected: (_) => set(slot, null),
                ),
              for (final it in catalog.where(
                  (i) => i.slot == slot && owned.contains(i.id) && i.fitsBody(profile.body)))
                ChoiceChip(
                  label: Text(it.name),
                  selected: (profile.equipped[slot]?.id ??
                          (slot == ItemSlot.fondo ? defaultBackground : null)) ==
                      it.id,
                  onSelected: (_) => set(slot, Equipped(it.id, it.defaultColorFor(profile.sceneTone))),
                ),
            ]),
            if (profile.equipped[slot] case final e?)
              if (itemById(e.id)?.recolor != null) ...[
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (var i = 0; i < itemById(e.id)!.colors.length; i++)
                    GestureDetector(
                      onTap: () => set(slot, Equipped(e.id, i)),
                      child: Tooltip(
                        message: itemById(e.id)!.colors[i].name,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Color(0xFF000000 | itemById(e.id)!.colors[i].main),
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: e.color == i ? 3 : 1,
                                color: e.color == i
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outlineVariant),
                          ),
                        ),
                      ),
                    ),
                ]),
              ],
          ],
        ]),
      ),
    );
  }
}
