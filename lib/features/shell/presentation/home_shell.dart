import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n.dart';

/// Bottom navigation on phones, a side rail on tablets, laptops and TVs.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.shell, super.key});

  static const double railBreakpoint = 840;

  final StatefulNavigationShell shell;

  void _go(int index) =>
      shell.goBranch(index, initialLocation: index == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final destinations = [
      (Icons.campaign_outlined, Icons.campaign, l10n.navCaller),
      (
        Icons.confirmation_number_outlined,
        Icons.confirmation_number,
        l10n.navTickets,
      ),
      (Icons.fact_check_outlined, Icons.fact_check, l10n.navClaims),
    ];
    final wide = MediaQuery.sizeOf(context).width >= railBreakpoint;
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _go,
        destinations: [
          for (final (icon, selected, label) in destinations)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(selected),
              label: label,
            ),
        ],
      ),
    );
  }
}
