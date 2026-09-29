import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_state.dart';
import 'backup.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appDataProvider);
    void msg(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(children: [
        const ListTile(
          title: Text('Tus datos'),
          subtitle: Text('Se guardan solo en este dispositivo. Sin cuenta, sin nube.'),
        ),
        ListTile(
          leading: const Icon(Icons.upload_outlined),
          title: const Text('Exportar respaldo'),
          subtitle: Text('${data.habits.length} hábitos · ${data.tasks.length} tareas — incluye monedas, compras y personaje; copia el JSON al portapapeles'),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: await buildBackup(ref)));
            msg('Respaldo copiado al portapapeles');
          },
        ),
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: const Text('Importar respaldo'),
          subtitle: const Text('Pega un JSON exportado. Reemplaza los datos actuales.'),
          onTap: () => _import(context, ref, msg),
        ),
        const Divider(),
        const AboutListTile(
          icon: Icon(Icons.info_outline),
          applicationName: 'Ritmo',
          applicationVersion: '0.1.0',
          aboutBoxChildren: [Text('Hábitos, tareas y calendario en una sola app.')],
        ),
      ]),
    );
  }

  Future<void> _import(BuildContext context, WidgetRef ref, void Function(String) msg) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar respaldo'),
        content: TextField(
          controller: ctrl,
          maxLines: 8,
          decoration: const InputDecoration(
              hintText: 'Pega aquí el JSON', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reemplazar datos')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await restoreBackup(ref, ctrl.text);
      msg('Datos importados');
    } catch (_) {
      msg('El texto no es un respaldo válido; no se cambió nada');
    }
  }
}
