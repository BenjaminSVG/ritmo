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
 * Widget "Mi personaje": la escena con el personaje (dibujada por la app Flutter como imagen), su nombre,
 * las monedas y el nivel. Al tocarlo se abre la app. Solo lectura.
 */
class CharacterWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        // Si el archivo no existe o está corrupto no se muestra imagen (no se rompe el widget).
        val bitmap = widgetData.getString("ch_image", null)
            ?.takeIf { File(it).exists() }
            ?.let { runCatching { BitmapFactory.decodeFile(it) }.getOrNull() }

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.character_widget).apply {
                setTextViewText(R.id.ch_title, widgetData.getString("ch_title", "Ritmo"))
                setTextViewText(R.id.ch_sub, widgetData.getString("ch_sub", "Abre la app para crear tu personaje"))
                if (bitmap != null) {
                    setImageViewBitmap(R.id.ch_image, bitmap)
                    setViewVisibility(R.id.ch_image, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.ch_image, View.GONE)
                }
                setOnClickPendingIntent(R.id.ch_root, WidgetIntents.open(context))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
