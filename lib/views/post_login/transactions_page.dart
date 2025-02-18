import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/views/utility/format_currency.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        constraints: BoxConstraints(maxWidth: 600),
        child: Consumer<AccountNotifier>(
          builder: (context, accountNotifier, child) =>
              accountNotifier.transactions.isEmpty
                  ? Text("No transaction found.")
                  : TransactionsListView(accountNotifier: accountNotifier),
        ),
      ),
    );
  }
}

class TransactionsListView extends StatelessWidget {
  final AccountNotifier _accountNotifier;

  const TransactionsListView({
    super.key,
    required AccountNotifier accountNotifier,
  }) : _accountNotifier = accountNotifier;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<PreferencesNotifier>(context).user!;
    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: _accountNotifier.transactions.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 8,
      ),
      itemBuilder: (context, idx) {
        final transaction = _accountNotifier.transactions[idx];
        return ListTile(
          title: Text(transaction.summary),
          subtitle: transaction.description == null
              ? null
              : Text(transaction.description!),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formatCurrency(
                      magnitude: transaction.amount,
                      precision: user.currencyPrecision,
                      currency: user.currency,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _accountNotifier.undoTransaction(transaction: transaction);
                  },
                  icon: Icon(Icons.undo),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
