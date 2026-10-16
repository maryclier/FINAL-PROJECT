import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      backgroundColor: const Color(0xFF58406B),
      indicatorColor: const Color(0xFFA970D8),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.coffee_outlined),
          selectedIcon: Icon(Icons.coffee_rounded),
          label: 'Menu',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_outlined),
          selectedIcon: Icon(Icons.auto_awesome_rounded),
          label: 'Quotes',
        ),
        NavigationDestination(
          icon: Icon(Icons.headphones_outlined),
          selectedIcon: Icon(Icons.headphones_rounded),
          label: 'Music',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
