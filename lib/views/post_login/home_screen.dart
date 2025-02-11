import 'package:flutter/material.dart';
import 'package:ledgerly/views/post_login/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void changeIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<BottomNavigationBarItem> bottomNavigationBarItems = [
      BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
      BottomNavigationBarItem(
          label: "Accounts", icon: Icon(Icons.account_balance)),
      BottomNavigationBarItem(label: "Debts", icon: Icon(Icons.pending)),
      BottomNavigationBarItem(label: "Settings", icon: Icon(Icons.settings)),
    ];
    const List<Widget> bodies = [
      Placeholder(),
      Placeholder(),
      Placeholder(),
      SettingsPage(),
    ];
    assert(bottomNavigationBarItems.length == bodies.length);

    final body = bodies[currentIndex];

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final bool verticalLayout =
          0.9 * constraints.maxHeight > constraints.maxWidth;
      return Scaffold(
        appBar: AppBar(
          title: Text(bottomNavigationBarItems[currentIndex].label!),
        ),
        body: verticalLayout
            ? body
            : Row(
                children: [
                  NavigationRail(
                    destinations: [
                      for (BottomNavigationBarItem item
                          in bottomNavigationBarItems)
                        NavigationRailDestination(
                            icon: item.icon, label: Text(item.label!))
                    ],
                    selectedIndex: currentIndex,
                    onDestinationSelected: changeIndex,
                    labelType: NavigationRailLabelType.all,
                    extended: false,
                  ),
                  Expanded(child: body),
                ],
              ),
        bottomNavigationBar: verticalLayout
            ? BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: changeIndex,
                items: bottomNavigationBarItems,
                type: BottomNavigationBarType.fixed,
              )
            : null,
      );
    });
  }
}
