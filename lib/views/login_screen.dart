import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/view_models/login_screen.dart';
import 'package:ledgerly/views/add_user_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _UserPicker(),
      appBar: AppBar(
        title: Text("Pick a user"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddUserScreen(),
        )),
        label: Text("New User"),
        icon: Icon(Icons.add),
        isExtended: true,
      ),
    );
  }
}

class _UserPicker extends StatelessWidget {
  const _UserPicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Consumer<LoginScreenViewModel>(
          builder: (context, viewModel, child) => viewModel.users.isEmpty
              ? Text("No users found.")
              : _UserListView(viewModel: viewModel),
        ),
      ),
    );
  }
}

class _UserListView extends StatelessWidget {
  final LoginScreenViewModel viewModel;

  const _UserListView({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: viewModel.users.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 8,
      ),
      itemBuilder: (context, idx) {
        final user = viewModel.users[idx];
        return ListTile(
          title: Text(user.name),
          onTap: () {
            Provider.of<PreferencesNotifier>(
              context,
              listen: false,
            ).login(userId: user.id);
          },
          trailing: IconButton(
            onPressed: () {
              viewModel.deleteUser(user.id);
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
      padding: EdgeInsets.only(bottom: 80),
    );
  }
}
