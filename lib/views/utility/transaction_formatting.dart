import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';

String getCharForTransactionType(final TransactionType type) => switch (type) {
      TransactionType.incoming => '+',
      TransactionType.outgoing => '−',
      TransactionType.internalTransfer => '⇆'
    };

const List<ButtonSegment<TransactionType>> transactionTypeButtonSegments = [
  ButtonSegment(
    value: TransactionType.incoming,
    label: Text('Income'),
    icon: Icon(Icons.download),
  ),
  ButtonSegment(
    value: TransactionType.outgoing,
    label: Text('Expense'),
    icon: Icon(Icons.upload),
  ),
  ButtonSegment(
    value: TransactionType.internalTransfer,
    label: Text('Transfer'),
    icon: Icon(Icons.swap_vert),
  ),
];

Icon getIconForTransactionType(final TransactionType type) => Icon(
      switch (type) {
        TransactionType.incoming => Icons.download,
        TransactionType.outgoing => Icons.upload,
        TransactionType.internalTransfer => Icons.swap_vert,
      },
    );
