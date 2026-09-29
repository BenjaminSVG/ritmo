package com.ritmo.ritmo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

/**
 * Widget "Racha y calendario": título y racha de un hábito, con su calendario de
 * calor de 12 semanas. El calendario lo dibuja la app Flutter como imagen y
 * este widget solo la muestra. Solo lectura.
 */
class HeatmapWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        // Si el archivo no existe o está corrupto no se muestra imagen (no se rompe el widget).
        val bitmap = widgetData.getString("hm_image", null)
            ?.takeIf { File(it).exists() }
            ?.let { runCatching { BitmapFactory.decodeFile(it) }.getOrNull() }

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.heatmap_widget).apply {
                setTextViewText(R.id.hm_title, widgetData.getString("hm_title", "Ritmo"))
                setTextViewText(R.id.hm_sub, widgetData.getString("hm_sub", ""))
                if (bitmap != null) {
                    setImageViewBitmap(R.id.hm_image, bitmap)
                    setViewVisibility(R.id.hm_image, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.hm_image, View.GONE)
                }
                setOnClickPendingIntent(R.id.hm_root, WidgetIntents.open(context))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
