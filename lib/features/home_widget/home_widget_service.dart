import 'dart:io';

import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

/// The strings the Android widget renders. Built outside the platform layer so
/// the formatting is testable without a device.
class HomeWidgetData {
  const HomeWidgetData({required this.title, required this.plan, required this.next, required this.updated});

  final String title;
  final String plan;
  final String next;
  final String updated;
}

HomeWidgetData buildHomeWidgetData({
  required List<EntryOccurrence> todayEntries,
  required List<ShiftOccurrence> todayShifts,
  required Iterable<ShiftOccurrence> upcomingShifts,
  required DateTime now,
  required String timeZone,
  required String title,
  required String emptyText,
  required String nextPrefix,
}) {
  final plan = <String>[
    for (final shift in todayShifts)
      if (shift.slot.label.isEmpty) shift.pattern.name else '${shift.pattern.name} · ${shift.slot.label}',
    for (final entry in todayEntries) entry.entry.title,
  ];
  final next = upcomingShifts.where((shift) => shift.startAt.isAfter(now)).toList()
    ..sort((a, b) => a.startAt.compareTo(b.startAt));
  final localNow = localDateTimeAt(now, timeZone);

  return HomeWidgetData(
    title: title,
    plan: plan.isEmpty ? emptyText : plan.take(3).join(' · '),
    next: next.isEmpty
        ? ''
        : '$nextPrefix${next.first.pattern.name}'
              '${next.first.slot.label.isEmpty ? '' : ' · ${next.first.slot.label}'}',
    updated: DateFormat.Hm().format(localNow),
  );
}

///
/// This is best effort and Android-only. Desktop and tests have no provider, so
/// a missing platform channel is not an error for the planner.
class HomeWidgetService {
  static const androidProvider = 'ManeTodayWidgetProvider';

  Future<void> update(HomeWidgetData data) async {
    if (!Platform.isAndroid) return;
    try {
      await HomeWidget.saveWidgetData<String>('mane_widget_title', data.title);
      await HomeWidget.saveWidgetData<String>('mane_widget_plan', data.plan);
      await HomeWidget.saveWidgetData<String>('mane_widget_next', data.next);
      await HomeWidget.saveWidgetData<String>('mane_widget_updated', data.updated);
      await HomeWidget.updateWidget(androidName: androidProvider);
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }
}
