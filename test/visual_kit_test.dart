import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/widgets/ui_kit.dart';
import 'package:mane/theme/app_colors.dart';
import 'package:mane/theme/app_theme.dart';

void main() {
  testWidgets('the theme carries Mane tokens, Nunito and component shapes', (tester) async {
    final theme = ManeTheme.light;
    final colors = theme.extension<ManeColors>();

    expect(colors, isNotNull);
    expect(colors!.accent, ManeColors.light.accent);
    expect(theme.textTheme.bodyMedium?.fontFamily, 'Nunito');
    expect(theme.textTheme.displayLarge?.fontWeight, FontWeight.w800);
    expect(theme.appBarTheme.backgroundColor, Colors.transparent);
    expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
    expect(theme.filledButtonTheme.style?.shape?.resolve({}), isA<StadiumBorder>());
    expect(theme.bottomSheetTheme.shape, isA<RoundedRectangleBorder>());
    expect(theme.cardTheme.color, ManeColors.light.surface);
  });

  testWidgets('the shared kit renders and responds', (tester) async {
    var taps = 0;
    var toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ManeTheme.light,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SectionLabel('Today'),
                SoftCard(
                  child: Pressable(onTap: () => setState(() => taps++), child: const Text('Pressable row')),
                ),
                TinySwitch(
                  value: toggled,
                  onChanged: (value) => setState(() => toggled = value),
                  semanticLabel: 'Quiet hours',
                ),
                const AppEmptyState(icon: Icons.event_note, title: 'Nothing planned', compact: true),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('TODAY'), findsOneWidget);
    expect(find.byType(SoftCard), findsOneWidget);
    expect(find.text('Nothing planned'), findsOneWidget);

    await tester.tap(find.text('Pressable row'));
    await tester.pumpAndSettle();
    expect(taps, 1);

    await tester.tap(find.bySemanticsLabel('Quiet hours'));
    await tester.pumpAndSettle();
    expect(toggled, isTrue);
  });

  testWidgets('the floating nav reports the selected destination', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: ManeTheme.light,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => Align(
              alignment: Alignment.bottomCenter,
              child: ManeNavBar(
                index: selected,
                onSelected: (value) => setState(() => selected = value),
                items: const [
                  (icon: Icons.today_outlined, selectedIcon: Icons.today, label: 'Today'),
                  (
                    icon: Icons.calendar_view_week_outlined,
                    selectedIcon: Icons.calendar_view_week,
                    label: 'Week',
                  ),
                  (
                    icon: Icons.calendar_month_outlined,
                    selectedIcon: Icons.calendar_month,
                    label: 'Calendar',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Week'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('a pushed page uses the custom header, not an AppBar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ManeTheme.light,
        home: const ManePage(title: 'Tags', subtitle: 'Jobs and people', child: Text('Body')),
      ),
    );

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Tags'), findsOneWidget);
    expect(find.text('Jobs and people'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });

  testWidgets('a sheet opens with the reference handle and title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ManeTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showAppSheet<void>(
                  context: context,
                  builder: (context) =>
                      const AppSheet(title: 'Reminders', children: [Text('At the start time')]),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(SheetHandle), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('At the start time'), findsOneWidget);
  });
}
