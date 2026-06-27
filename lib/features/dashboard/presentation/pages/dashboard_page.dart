import 'package:flutter/material.dart';

import '../../../attendance/presentation/pages/attendance_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../payments/presentation/pages/payments_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../widgets/dashboard_bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),

    AttendancePage(),

    PaymentsPage(),

    ProfilePage(),

    SettingsPage(),
  ];

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _selectedIndex,

        onTap: _changeTab,
      ),
    );
  }
}
