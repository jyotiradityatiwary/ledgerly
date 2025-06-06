import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/login_notifier.dart';
import 'package:ledgerly/views/accounts/add_account_screen.dart';
import 'package:ledgerly/views/accounts/add_transaction_screen.dart';
import 'package:ledgerly/views/accounts/transactions_page.dart';
import 'package:ledgerly/views/reusable/content_container.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountNotifier>(
      builder: (context, accountNotifier, child) => accountNotifier.isLoaded
          ? ContentList(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "My Accounts",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddOrModifyAccountScreen(),
                            ));
                          },
                          icon: Icon(Icons.add))
                    ],
                  ),
                ),
                accountNotifier.accounts.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "No account found.",
                        ),
                      )
                    : _AccountListView(
                        accountNotifier: accountNotifier,
                      ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Recent Transactions",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                accountNotifier.transactions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No transaction found.',
                        ),
                      )
                    : TransactionsListView(
                        accountNotifier: accountNotifier,
                      ),
              ],
            )
          : child!,
      child: const Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Loading accounts and transactions..."),
            CircularProgressIndicator.adaptive(),
          ],
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
    final user = Provider.of<LoginNotifier>(context).user!;
    final theme = Theme.of(context);

    return SizedBox(
      height: 100,
      child: ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: accountNotifier.accounts.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(
          width: 8,
        ),
        itemBuilder: (context, idx) {
          final account = accountNotifier.accounts[idx];
          return SizedBox(
            width: 150,
            child: MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddOrModifyAccountScreen(
                        account: account,
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
                  onPressed: () => accountNotifier.hasTransactions(account.id)
                      ? showAdaptiveDialog(
                          context: context,
                          builder: (context) =>
                              _ShouldDeleteAccountWithTransactionsDialog(
                            account: account,
                            accountNotifier: accountNotifier,
                          ),
                        )
                      : accountNotifier.deleteAccount(id: account.id),
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
              builder: (context, controller, child) {
                void toggle() =>
                    controller.isOpen ? controller.close() : controller.open();
                return InkWell(
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Long press or right click for options."),
                      duration: Duration(seconds: 2),
                      showCloseIcon: true,
                    ),
                  ),
                  onLongPress: toggle,
                  onSecondaryTap: toggle,
                  child: child,
                );
              },
              style: theme.menuTheme.style?.copyWith(
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => theme.colorScheme.primaryContainer,
                ),
                elevation: WidgetStatePropertyAll(4.0),
              ),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      account.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(user.formatIntMoney(account.currentBalance)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShouldDeleteAccountWithTransactionsDialog extends StatelessWidget {
  const _ShouldDeleteAccountWithTransactionsDialog({
    required this.accountNotifier,
    required this.account,
  });

  final AccountNotifier accountNotifier;
  final Account account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog.adaptive(
      title: Text('Warning'),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        child: Text(
          'This acount has transactions associated to it.\n\nIf you continue to delete this account, all transactions that are linked to this account will also be deleted.',
          softWrap: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            accountNotifier.deleteAccountWithAssociatedTransactions(
                accountId: account.id);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
          child: Text('Continue'),
        )
      ],
    );
  }
}

class AccountsPageFAB extends StatelessWidget {
  const AccountsPageFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        if (Provider.of<AccountNotifier>(context, listen: false)
            .accounts
            .isEmpty) {
          final bool shouldAddAccountNow = await showDialog<bool>(
                context: context,
                builder: (context) => _AddAccountFirstDialog(),
              ) ??
              false;
          if (shouldAddAccountNow && context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddOrModifyAccountScreen(),
            ));
          }
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddTransactionScreen(),
          ));
        }
      },
      label: Text('New Transaction'),
      icon: Icon(Icons.create),
    );
  }
}

class _AddAccountFirstDialog extends StatelessWidget {
  const _AddAccountFirstDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
          'An account is needed to add transactions. Would you like to add an account now?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<bool>(false),
          child: Text('Later'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop<bool>(true),
          child: Text('Add Account'),
        ),
      ],
    );
  }
}
