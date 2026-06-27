import 'package:flutter/material.dart';

class DashboardBottomNav extends StatelessWidget {

  final int currentIndex;

  final ValueChanged<int> onTap;

  const DashboardBottomNav({

    super.key,

    required this.currentIndex,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return NavigationBar(

      selectedIndex: currentIndex,

      onDestinationSelected: onTap,

      destinations: const [

        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.fact_check_outlined,
          ),
          selectedIcon: Icon(
            Icons.fact_check,
          ),
          label: 'Attendance',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.payments_outlined,
          ),
          selectedIcon: Icon(
            Icons.payments,
          ),
          label: 'Payments',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
          ),
          selectedIcon: Icon(
            Icons.person,
          ),
          label: 'Profile',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.settings_outlined,
          ),
          selectedIcon: Icon(
            Icons.settings,
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}