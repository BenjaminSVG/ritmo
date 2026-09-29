package com.ritmo.ritmo

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/** Widget "Hábitos": hasta 6 hábitos de hoy con su estado ("✓", "3/8 vasos", "0/1"). Solo lectura. */
class HabitsWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val names = intArrayOf(R.id.hb_name1, R.id.hb_name2, R.id.hb_name3, R.id.hb_name4, R.id.hb_name5, R.id.hb_name6)
        val statuses = intArrayOf(R.id.hb_status1, R.id.hb_status2, R.id.hb_status3, R.id.hb_status4, R.id.hb_status5, R.id.hb_status6)
        val rows = intArrayOf(R.id.hb_row1, R.id.hb_row2, R.id.hb_row3, R.id.hb_row4, R.id.hb_row5, R.id.hb_row6)

        appWidgetIds.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.habits_widget).apply {
                setTextViewText(R.id.hb_progress, widgetData.getString("hb_progress", ""))
                val empty = widgetData.getString("hb_empty", "") ?: ""
                setTextViewText(R.id.hb_empty, empty)
                setViewVisibility(R.id.hb_empty, if (empty.isEmpty()) View.GONE else View.VISIBLE)
                rows.indices.forEach { i ->
                    val name = widgetData.getString("hb_name${i + 1}", "") ?: ""
                    setTextViewText(names[i], name)
                    setTextViewText(statuses[i], widgetData.getString("hb_status${i + 1}", ""))
                    setViewVisibility(rows[i], if (name.isEmpty()) View.GONE else View.VISIBLE)
                }
                setOnClickPendingIntent(R.id.hb_root, WidgetIntents.open(context))
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
