import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledgerly/model/data_classes.dart';
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
    final DateFormat dateFormat = DateFormat.yMMMd().add_jm();

    return ListView.separated(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: _accountNotifier.transactions.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 8,
      ),
      itemBuilder: (context, idx) {
        final transaction = _accountNotifier.transactions[idx];

        // atleast one of sourceAccount or destinationAccount must be set
        assert(transaction.sourceAccount != null ||
            transaction.destinationAccount != null);

        final TransactionType type = transaction.destinationAccount == null
            ? TransactionType.outgoing
            : transaction.sourceAccount == null
                ? TransactionType.incoming
                : TransactionType.internalTransfer;

        final String formattedAmount = formatCurrency(
          magnitude: transaction.amount,
          maxPrecision: user.currencyPrecision,
          currency: user.currency,
        );
        final String formattedTime = dateFormat.format(transaction.dateTime);

        return ListTile(
          title: Text(transaction.summary),
          subtitle: Text(
            formattedTime,
            // style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        switch (type) {
                              TransactionType.incoming => '+ ',
                              TransactionType.outgoing => '− ',
                              TransactionType.internalTransfer => '⇆ '
                            } +
                            formattedAmount,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Text(
                    switch (type) {
                      TransactionType.incoming =>
                        'to ${transaction.destinationAccount!.name}',
                      TransactionType.outgoing =>
                        'from ${transaction.sourceAccount!.name}',
                      TransactionType.internalTransfer =>
                        '${transaction.sourceAccount!.name} to ${transaction.destinationAccount!.name}'
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              IconButton(
                onPressed: () =>
                    Provider.of<AccountNotifier>(context, listen: false)
                        .undoTransaction(transactionId: transaction.id),
                icon: Icon(Icons.undo),
              ),
            ],
          ),
        );
      },
    );
  }
}
