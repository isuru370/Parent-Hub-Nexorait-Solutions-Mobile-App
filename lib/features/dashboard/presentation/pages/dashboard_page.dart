import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/dashboard_bottom_nav.dart';

class DashboardPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardPage({super.key, required this.navigationShell});

  void _changeTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
