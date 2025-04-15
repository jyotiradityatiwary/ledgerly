import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/login_notifier.dart';
import 'package:ledgerly/notifiers/user_notifier.dart';
import 'package:ledgerly/views/users/add_user_screen.dart';
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
          builder: (context) => AddOrModifyUserScreen(),
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
        child: Consumer<UserNotifier>(
          builder: (context, viewModel, child) => viewModel.users.isEmpty
              ? Text("No users found.")
              : _UserListView(viewModel: viewModel),
        ),
      ),
    );
  }
}

class _UserListView extends StatelessWidget {
  final UserNotifier viewModel;

  const _UserListView({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            Provider.of<LoginNotifier>(
              context,
              listen: false,
            ).login(userId: user.id);
          },
          trailing: MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddOrModifyUserScreen(
                      user: user,
                    ),
                  ));
                },
                leadingIcon: Icon(Icons.edit),
                child: Text(
                  'Edit',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              MenuItemButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) => _AccountDeletionConfirmationDialog(
                      userId: user.id,
                    ),
                  );
                },
                leadingIcon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.error,
                ),
                child: Text(
                  'Delete',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: theme.colorScheme.error),
                ),
              ),
            ],
            builder: (context, controller, child) => IconButton(
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              icon: child!,
            ),
            child: Icon(Icons.more_vert),
          ),
        );
      },
      padding: EdgeInsets.only(bottom: 80),
    );
  }
}

class _AccountDeletionConfirmationDialog extends StatelessWidget {
  const _AccountDeletionConfirmationDialog({
    required this.userId,
  });

  final int userId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text('Warning'),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        child: Text(
          'Deleting this user will delete all data (accounts, transactions, budgets, dues, cloud login details, etc) for this user. Do you want to continue?',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Provider.of<UserNotifier>(context).deleteUser(userId);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text('Continue'),
        )
      ],
    );
  }
}
