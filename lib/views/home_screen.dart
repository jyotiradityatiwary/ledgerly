import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/home_screen_notifier.dart';
import 'package:ledgerly/views/accounts/accounts_page.dart';
import 'package:ledgerly/views/insights/insights.dart';
import 'package:ledgerly/views/settings.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const List<_Destination> _destinations = [
    _Destination(
      title: 'Accounts',
      icon: Icon(Icons.payment),
      body: AccountsPage(),
      floatingActionButton: AccountsPageFAB(),
    ),
    _Destination(
      title: 'Insights',
      icon: Icon(Icons.insights),
      body: InsightsPage(),
      floatingActionButton: InsightsPageFAB(),
    ),
    _Destination(
      title: 'Dues',
      icon: Icon(Icons.pending_actions),
      body: Placeholder(),
      floatingActionButton: null,
    ),
    _Destination(
      title: 'Settings',
      icon: Icon(Icons.settings),
      body: SettingsPage(),
      floatingActionButton: null,
    )
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    for (final destination in _destinations)
      BottomNavigationBarItem(
        label: destination.title,
        icon: destination.icon,
      )
  ];

  final List<NavigationRailDestination> _navigationRailDestinations = [
    for (final destination in _destinations)
      NavigationRailDestination(
        icon: destination.icon,
        label: Text(destination.title),
      )
  ];

  @override
  Widget build(context) => LayoutBuilder(
        builder: (context, constraints) => _Scaffold(
          destinations: _destinations,
          bottomNavigationBarItems: _bottomNavigationBarItems,
          navigationRailDestinations: _navigationRailDestinations,
          verticalLayout: 0.9 * constraints.maxHeight > constraints.maxWidth,
        ),
      );
}

class _Scaffold extends StatefulWidget {
  final List<_Destination> _destinations;
  final List<BottomNavigationBarItem> _bottomNavigationBarItems;
  final List<NavigationRailDestination> _navigationRailDestinations;
  final bool verticalLayout;

  const _Scaffold({
    required List<_Destination> destinations,
    required List<BottomNavigationBarItem> bottomNavigationBarItems,
    required List<NavigationRailDestination> navigationRailDestinations,
    required this.verticalLayout,
  })  : _navigationRailDestinations = navigationRailDestinations,
        _bottomNavigationBarItems = bottomNavigationBarItems,
        _destinations = destinations;

  @override
  State<_Scaffold> createState() => _ScaffoldState();
}

class _ScaffoldState extends State<_Scaffold> {
  final HomeScreenNotifier notifier = HomeScreenNotifier();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: notifier,
        builder: (context, child) {
          return Scaffold(
            floatingActionButton: widget
                ._destinations[notifier.navBarSelection].floatingActionButton,
            body: SafeArea(
              child: widget.verticalLayout
                  ? widget._destinations[notifier.navBarSelection].body
                  : Row(
                      children: [
                        NavigationRail(
                          destinations: widget._navigationRailDestinations,
                          selectedIndex: notifier.navBarSelection,
                          onDestinationSelected: notifier.changeNavBarSelection,
                          labelType: NavigationRailLabelType.all,
                          extended: false,
                        ),
                        Expanded(
                            child: widget
                                ._destinations[notifier.navBarSelection].body),
                      ],
                    ),
            ),
            bottomNavigationBar: widget.verticalLayout
                ? BottomNavigationBar(
                    currentIndex: notifier.navBarSelection,
                    onTap: notifier.changeNavBarSelection,
                    items: widget._bottomNavigationBarItems,
                    type: BottomNavigationBarType.fixed,
                  )
                : null,
          );
        });
  }
}

class _Destination {
  final String title;
  final Icon icon;
  final Widget body;
  final Widget? floatingActionButton;

  const _Destination({
    required this.title,
    required this.icon,
    required this.body,
    required this.floatingActionButton,
  });
}
