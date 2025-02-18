import 'package:flutter/material.dart';
import 'package:ledgerly/views/post_login/accounts_page.dart';
import 'package:ledgerly/views/post_login/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void changeIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

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
      body: Placeholder(),
      floatingActionButton: null,
    ),
    _Destination(
      title: 'Dues',
      icon: Icon(Icons.pending_actions),
      body: Placeholder(),
      floatingActionButton: null,
    ),
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
          currentIndex: _currentIndex,
          changeIndex: changeIndex,
          verticalLayout: 0.9 * constraints.maxHeight > constraints.maxWidth,
        ),
      );
}

class _Scaffold extends StatelessWidget {
  final List<_Destination> _destinations;
  final List<BottomNavigationBarItem> _bottomNavigationBarItems;
  final List<NavigationRailDestination> _navigationRailDestinations;
  final int _currentIndex;
  final void Function(int) _changeIndex;
  final bool verticalLayout;

  const _Scaffold({
    required List<_Destination> destinations,
    required List<BottomNavigationBarItem> bottomNavigationBarItems,
    required List<NavigationRailDestination> navigationRailDestinations,
    required int currentIndex,
    required void Function(int) changeIndex,
    required this.verticalLayout,
  })  : _changeIndex = changeIndex,
        _currentIndex = currentIndex,
        _navigationRailDestinations = navigationRailDestinations,
        _bottomNavigationBarItems = bottomNavigationBarItems,
        _destinations = destinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_destinations[_currentIndex].title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      floatingActionButton: _destinations[_currentIndex].floatingActionButton,
      body: verticalLayout
          ? _destinations[_currentIndex].body
          : Row(
              children: [
                NavigationRail(
                  destinations: _navigationRailDestinations,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _changeIndex,
                  labelType: NavigationRailLabelType.all,
                  extended: false,
                ),
                Expanded(child: _destinations[_currentIndex].body),
              ],
            ),
      bottomNavigationBar: verticalLayout
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _changeIndex,
              items: _bottomNavigationBarItems,
              type: BottomNavigationBarType.fixed,
            )
          : null,
    );
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
