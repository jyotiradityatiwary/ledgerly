import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/views/post_login/add_account_screen.dart';
import 'package:ledgerly/views/post_login/add_transaction_screen.dart';
import 'package:ledgerly/views/post_login/transactions_page.dart';
import 'package:ledgerly/views/utility/format_currency.dart';
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
          builder: (context, accountNotifier, child) => accountNotifier.isLoaded
              ? ListView(
                  padding: EdgeInsets.only(bottom: 80),
                  shrinkWrap: true,
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
                                  builder: (context) => AddAccountScreen(),
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
                      child: Text(
                        "Recent Transactions",
                        style: Theme.of(context).textTheme.titleMedium,
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
    final user = Provider.of<PreferencesNotifier>(context).user!;

    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: accountNotifier.accounts.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 8,
      ),
      itemBuilder: (context, idx) {
        final account = accountNotifier.accounts[idx];
        return ListTile(
          title: Row(
            children: [
              Expanded(child: Text(account.name)),
              Text(
                formatCurrency(
                  magnitude: account.currentBalance,
                  precision: user.currencyPrecision,
                  currency: user.currency,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          subtitle:
              account.description == null ? null : Text(account.description!),
          trailing: IconButton(
            onPressed: () {
              accountNotifier.deleteAccount(id: account.id);
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
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
          builder: (context) => AddTransactionScreen(),
        ));
      },
      label: Text('New Transaction'),
      icon: Icon(Icons.create),
    );
  }
}
