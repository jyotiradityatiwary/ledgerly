import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/views/post_login/add_account_screen.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        constraints: BoxConstraints(maxWidth: 600),
        child: Consumer<AccountNotifier>(
          builder: (context, accountNotifier, child) =>
              accountNotifier.accounts.isEmpty
                  ? Text("No account found.")
                  : _AccountListView(accountNotifier: accountNotifier),
        ),
      ),
    );
  }
}

class _AccountListView extends StatelessWidget {
  final AccountNotifier accountNotifier;

  const _AccountListView({
    required this.accountNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: accountNotifier.accounts.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 8,
      ),
      itemBuilder: (context, idx) {
        final account = accountNotifier.accounts[idx];
        return ListTile(
          title: Text(account.name),
          subtitle:
              account.description == null ? null : Text(account.description!),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    Provider.of<PreferencesNotifier>(context).user!.currency +
                        account.currentBalance.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    accountNotifier.deleteAccount(id: account.id);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
      padding: EdgeInsets.only(bottom: 80),
    );
  }
}

class AccountsPageFAB extends StatelessWidget {
  const AccountsPageFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddAccountScreen(),
        ));
      },
      label: Text('Add Account'),
      icon: Icon(Icons.create),
    );
  }
}
