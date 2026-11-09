import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/entry_editor.dart';
import '../screens/today_screen.dart';
import '../screens/week_screen.dart';
import '../state/providers.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;

    return Scaffold(
      body: IndexedStack(index: _index, children: const [TodayScreen(), WeekScreen()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEntryEditor(context, spaces: spaces),
        tooltip: 'Add an entry',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.today_outlined),
            selectedIcon: Icon(Icons.today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_view_week_outlined),
            selectedIcon: Icon(Icons.calendar_view_week),
            label: 'Week',
          ),
        ],
      ),
    );
  }
}
