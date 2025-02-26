import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/services/database_manager.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final children = <ListTile>[
      ListTile(
        title: Text("Logout"),
        onTap: () {
          Provider.of<PreferencesNotifier>(
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
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 80),
          separatorBuilder: (context, index) => SizedBox(
            height: 8,
          ),
          itemBuilder: (context, index) => children[index],
          itemCount: children.length,
        ),
      ),
    );
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
