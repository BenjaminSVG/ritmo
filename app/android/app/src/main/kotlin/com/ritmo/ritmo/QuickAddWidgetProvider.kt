package com.ritmo.ritmo

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

/** Widget "Añadir rápido": un botón "+" que abre la app con "Nueva tarea". No necesita datos. */
class QuickAddWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.quick_add_widget).apply {
                setOnClickPendingIntent(R.id.qa_root, WidgetIntents.add(context))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
