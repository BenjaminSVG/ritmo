package com.ritmo.ritmo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Widget "Hoy": lee un resumen (título, progreso y hasta 5 líneas) que la app
 * Flutter guarda con home_widget, y lo dibuja. Solo lectura: tocar abre la app;
 * el botón "+" abre la app con "Nueva tarea".
 */
class TodayWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val lineIds = intArrayOf(R.id.w_line1, R.id.w_line2, R.id.w_line3, R.id.w_line4, R.id.w_line5)

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.today_widget).apply {
                setTextViewText(R.id.w_title, widgetData.getString("w_title", "Hoy"))
                setTextViewText(R.id.w_progress, widgetData.getString("w_progress", ""))
                lineIds.forEachIndexed { i, viewId ->
                    val text = widgetData.getString("w_line${i + 1}", "") ?: ""
                    setTextViewText(viewId, text)
                    setViewVisibility(viewId, if (text.isEmpty()) View.GONE else View.VISIBLE)
                }
                setOnClickPendingIntent(R.id.w_root, WidgetIntents.open(context))
                setOnClickPendingIntent(R.id.w_add, WidgetIntents.add(context))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
