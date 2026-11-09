package io.github.gabrieleancillai.mane

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class ManeTodayWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val next = widgetData.getString("mane_widget_next", null) ?: ""
            val views = RemoteViews(context.packageName, R.layout.mane_today_widget).apply {
                setTextViewText(
                    R.id.widget_title,
                    widgetData.getString("mane_widget_title", null) ?: "Mane",
                )
                setTextViewText(
                    R.id.widget_plan,
                    widgetData.getString("mane_widget_plan", null) ?: "",
                )
                setTextViewText(R.id.widget_next, next)
                setViewVisibility(R.id.widget_next, if (next.isEmpty()) View.GONE else View.VISIBLE)
                setTextViewText(
                    R.id.widget_updated,
                    widgetData.getString("mane_widget_updated", null) ?: "",
                )
                setOnClickPendingIntent(
                    R.id.widget_container,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
