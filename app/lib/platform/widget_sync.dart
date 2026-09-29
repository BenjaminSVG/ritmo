import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../domain/models.dart';
import '../domain/streaks.dart';
import '../domain/today_summary.dart';
import '../pixel/avatar_profile.dart';
import '../pixel/catalog.dart';
import '../pixel/pixel_assets.dart';
import '../pixel/pixel_avatar.dart';

/// Entrega a los widgets de pantalla de inicio (Android) los datos que
/// dibujan. En otras plataformas no hace nada.
class WidgetSync {
  WidgetSync._();

  static bool get _supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static Future<void> update(List<Habit> habits, List<Task> tasks) async {
    if (!_supported) return;
    final now = DateTime.now();
    await _today(habits, tasks, now);
    await _habits(habits, now);
    await _heatmap(habits, now);
  }

  static Future<void> _today(List<Habit> habits, List<Task> tasks, DateTime now) async {
    final s = buildTodaySummary(habits, tasks, now);
    await HomeWidget.saveWidgetData<String>('w_title', 'Hoy');
    await HomeWidget.saveWidgetData<String>('w_progress', s.progress);
    for (var i = 0; i < 5; i++) {
      await HomeWidget.saveWidgetData<String>(
          'w_line${i + 1}', i < s.lines.length ? s.lines[i] : '');
    }
    await HomeWidget.updateWidget(androidName: 'TodayWidgetProvider');
  }

  static Future<void> _habits(List<Habit> habits, DateTime now) async {
    final (progress, rows) = buildHabitsSummary(habits, now);
    await HomeWidget.saveWidgetData<String>('hb_progress', progress);
    for (var i = 0; i < 6; i++) {
      await HomeWidget.saveWidgetData<String>('hb_name${i + 1}', i < rows.length ? rows[i].name : '');
      await HomeWidget.saveWidgetData<String>('hb_status${i + 1}', i < rows.length ? rows[i].status : '');
    }
    await HomeWidget.saveWidgetData<String>(
        'hb_empty', rows.isEmpty ? 'Sin hábitos para hoy' : '');
    await HomeWidget.updateWidget(androidName: 'HabitsWidgetProvider');
  }

  static Future<void> _heatmap(List<Habit> habits, DateTime now) async {
    final today = DateTime(now.year, now.month, now.day);
    final habit = pickHeatmapHabit(habits, (h) => currentStreak(h, today));
    if (habit == null) {
      await HomeWidget.saveWidgetData<String>('hm_title', 'Sin hábitos');
      await HomeWidget.saveWidgetData<String>('hm_sub', '');
      await HomeWidget.saveWidgetData<String>('hm_image', null);
    } else {
      await HomeWidget.saveWidgetData<String>('hm_title', '${habit.emoji} ${habit.name}');
      await HomeWidget.saveWidgetData<String>(
          'hm_sub', '🔥 ${currentStreak(habit, today)} · ${(completionRate(habit, today) * 100).round()}% (30 días)');
      // Dibuja el calendario de calor con Flutter y lo entrega como imagen.
      await HomeWidget.renderFlutterWidget(
        HeatmapImage(habit: habit, today: today),
        key: 'hm_image',
        logicalSize: const Size(heatmapWidth, heatmapHeight),
        pixelRatio: 3,
      );
    }
    await HomeWidget.updateWidget(androidName: 'HeatmapWidgetProvider');
  }
}

const heatmapWeeks = 12;
const heatmapCell = 14.0;
const heatmapGap = 3.0;
const heatmapWidth = heatmapWeeks * (heatmapCell + heatmapGap);
const heatmapHeight = 7 * (heatmapCell + heatmapGap);

/// Calendario de calor de [heatmapWeeks] semanas (columnas = semanas,
/// filas = lunes a domingo). Sin texto: el título lo dibuja el widget nativo.
class HeatmapImage extends StatelessWidget {
  const HeatmapImage({super.key, required this.habit, required this.today});
  final Habit habit;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.colorValue);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day - 7 * (heatmapWeeks - 1));
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(children: [
        for (var w = 0; w < heatmapWeeks; w++)
          Column(children: [
            for (var d = 0; d < 7; d++)
              Builder(builder: (_) {
                final day = DateTime(start.year, start.month, start.day + w * 7 + d);
                final future = day.isAfter(today);
                final done = habit.isDoneOn(day);
                final partial = !done && habit.valueOn(day) > 0;
                return Container(
                  width: heatmapCell,
                  height: heatmapCell,
                  margin: const EdgeInsets.all(heatmapGap / 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: future
                        ? Colors.transparent
                        : done
                            ? color
                            : partial
                                ? color.withValues(alpha: 0.4)
                                : const Color(0xFFDDDFE6),
                  ),
                );
              }),
          ]),
      ]),
    );
  }
}

/// Widget del personaje: la escena completa como imagen, con el nombre, las monedas y el nivel.
class CharacterWidgetSync {
  CharacterWidgetSync._();

  static const _scale = 3;

  static Future<void> update({
    required AvatarProfile profile,
    required String subtitle,
  }) async {
    if (!WidgetSync._supported) return;
    final avatar = await PixelAssets.resolve(profile);
    final bg = await PixelAssets.background(
        profile.equipped[ItemSlot.fondo]?.id ?? defaultBackground, profile.sceneTone);
    await HomeWidget.saveWidgetData<String>('ch_title', profile.name);
    await HomeWidget.saveWidgetData<String>('ch_sub', subtitle);
    await HomeWidget.renderFlutterWidget(
      SceneSnapshot(bg: bg, avatar: avatar, scale: _scale),
      key: 'ch_image',
      logicalSize: Size(PixelAssets.sceneW * _scale.toDouble(), PixelAssets.sceneH * _scale.toDouble()),
      pixelRatio: 1,
    );
    await HomeWidget.updateWidget(androidName: 'CharacterWidgetProvider');
  }
}
