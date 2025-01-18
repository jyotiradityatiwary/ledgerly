import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    const Widget body = Placeholder();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final bool verticalLayout =
          0.9 * constraints.maxHeight > constraints.maxWidth;
      return Scaffold(
        // appBar: AppBar(
        //   title: Text("Ledgerly"),
        // ),
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
