import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
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
