import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/login_notifier.dart';
import 'package:ledgerly/services/database_manager.dart';
import 'package:ledgerly/views/accounts/categories.dart';
import 'package:ledgerly/views/reusable/content_container.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = <ListTile>[
      ListTile(
        title: Text("Manage Categories"),
        subtitle: Text(
            "Add, rename, or remove the different categories that user can assign transactions to."),
        leading: Icon(Icons.category),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(),
          ),
        ),
      ),
      ListTile(
        title: Text("Logout"),
        onTap: () {
          Provider.of<LoginNotifier>(
            context,
            listen: false,
          ).logout();
        },
        subtitle: Text("Return to the user selection screen"),
        leading: Icon(Icons.logout),
      ),
      ListTile(
        title: Text("Debug Information"),
        leading: Icon(Icons.bug_report),
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Database File location: $dbPath"),
          ),
        ),
      ),
    ];
    return ContentList(children: children);
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsPage(),
    );
  }
}
