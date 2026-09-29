package com.ritmo.ritmo

import android.app.PendingIntent
import android.content.Context
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetLaunchIntent

/** Intents que abren la app desde un widget. La app Flutter lee la dirección (`ritmo://...`). */
object WidgetIntents {
    /** Abre la app en la pantalla principal. */
    fun open(context: Context): PendingIntent =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("ritmo://open"))

    /** Abre la app con la hoja "Nueva tarea" ya desplegada. */
    fun add(context: Context): PendingIntent =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("ritmo://add"))
}
