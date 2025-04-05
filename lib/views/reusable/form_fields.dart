import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/views/utility/format_currency.dart';
import 'package:ledgerly/views/utility/transaction_formatting.dart';
import 'package:provider/provider.dart';

class CurrencyInputFormField extends StatelessWidget {
  CurrencyInputFormField({
    super.key,
    required this.label,
    required this.onSaveAmount,
    required this.onFieldSubmitted,
    required this.currencyPrecision,
    required this.currency,
    this.autofocus = false,
    this.initialValue,
  });

  final String label;
  final void Function(int newAmount) onSaveAmount;
  final void Function(String value) onFieldSubmitted;
  final int currencyPrecision;
  final String currency;
  final bool autofocus;
  final int? initialValue;

  final RegExp balanceRegex = RegExp(r'^(\+|-)?(\d*)\.?(\d*)$');

  @override
  Widget build(BuildContext context) {
    final maxPrecision = currencyPrecision;
    final maxInputPrecision = maxPrecision - 1;
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
        prefixText: '$currency ',
        suffixIcon: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  "You can enter a decimal number (positive or negative). The decimal point can be followed by atmost $maxInputPrecision digits.",
                ),
              ),
            );
          },
          icon: Icon(Icons.info_outline_rounded),
        ),
      ),
      autofocus: autofocus,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      onFieldSubmitted: onFieldSubmitted,
      initialValue: initialValue == null
          ? null
          : formatCurrency(
              magnitude: initialValue!,
              maxPrecision: maxPrecision,
              currency: null,
            ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter an amount.";
        }
        final groups = balanceRegex.firstMatch(value);
        if (groups == null) return "Please enter a valid number";
        if ((groups[3] ?? '').length > maxInputPrecision) {
          return 'Maximum decimal precision allowed is $maxInputPrecision';
        }
        return null;
      },
      onSaved: (newValue) {
        final double amount =
            double.parse(newValue!) * math.pow(10, maxInputPrecision);
        onSaveAmount(amount.toInt());
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }
}

class DescriptionFormField extends StatelessWidget {
  const DescriptionFormField({
    super.key,
    required this.label,
    required this.onFieldSubmitted,
    required this.onSaved,
    this.autofocus = false,
    this.initialValue,
  });

  final String label;
  final void Function(String value) onFieldSubmitted;
  final void Function(String? newValue) onSaved;
  final bool autofocus;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text('$label (optional)'),
      ),
      onFieldSubmitted: onFieldSubmitted,
      onSaved: (newValue) =>
          onSaved(newValue == null || newValue == '' ? null : newValue),
      minLines: 2,
      maxLines: 4,
      autofocus: autofocus,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }
}

class NameFormField extends StatelessWidget {
  const NameFormField({
    super.key,
    required this.label,
    required this.onFieldSubmitted,
    required this.onSaved,
    this.autofocus = false,
    this.initialValue,
  });

  final String label;
  final void Function(String value) onFieldSubmitted;
  final void Function(String newValue) onSaved;
  final bool autofocus;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text(label),
      ),
      autofocus: autofocus,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter a value" : null,
      onSaved: (newValue) {
        onSaved(newValue!);
      },
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }
}

class TransactionTypePicker extends StatelessWidget {
  const TransactionTypePicker({
    super.key,
    required this.selection,
    required this.onSelectionChanged,
  });

  final TransactionType selection;
  final void Function(TransactionType newSelection) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: transactionTypeButtonSegments,
      selected: {selection},
      multiSelectionEnabled: false,
      emptySelectionAllowed: false,
      onSelectionChanged: (newSelections) =>
          onSelectionChanged(newSelections.single),
    );
  }
}

class TransactionTypeFormField extends StatelessWidget {
  final TransactionType initialValue;
  final void Function(TransactionType newValue) onSaved;

  const TransactionTypeFormField({
    super.key,
    required this.initialValue,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onSaved: (newValue) => onSaved(newValue!),
      builder: (final FormFieldState<TransactionType> field) =>
          TransactionTypePicker(
        selection: field.value!,
        onSelectionChanged: field.didChange,
      ),
    );
  }
}

class AccountPicker extends StatelessWidget {
  const AccountPicker({
    super.key,
    required this.label,
    required this.errorText,
    this.onSelected,
  });

  final String label;
  final String? errorText;
  final void Function(int? value)? onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      label: Text(label),
      enableFilter: true,
      enableSearch: true,
      requestFocusOnTap: false,
      errorText: errorText,
      width: 300,
      onSelected: onSelected,
      dropdownMenuEntries: Provider.of<AccountNotifier>(context)
          .accounts
          .map((Account account) => DropdownMenuEntry(
                value: account.id,
                label: account.name,
              ))
          .toList(),
    );
  }
}

class TransactionAccountAndCategoryFormField extends StatefulWidget {
  const TransactionAccountAndCategoryFormField({
    super.key,
    required this.onSaved,
  });

  final FormFieldSetter<TransactionAccountAndCategoryData> onSaved;

  @override
  State<TransactionAccountAndCategoryFormField> createState() =>
      _TransactionAccountAndCategoryFormFieldState();
}

class _TransactionAccountAndCategoryFormFieldState
    extends State<TransactionAccountAndCategoryFormField> {
  String? categoryPickerErrorText;
  void setCategoryPickerErrorText(String? value) {
    setState(() {
      categoryPickerErrorText = value;
    });
  }

  String? sourceAccountPickerErrorText;
  void setSourceAccountPickerErrorText(String? value) {
    setState(() {
      sourceAccountPickerErrorText = value;
    });
  }

  String? destinationAccountPickerErrorText;
  void setDestinationAccountPickerErrorText(String? value) {
    setState(() {
      destinationAccountPickerErrorText = value;
    });
  }

  final sourceAccountPickerKey = UniqueKey();
  final destinationAccountPickerKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return FormField<TransactionAccountAndCategoryData>(
      builder: (final FormFieldState<TransactionAccountAndCategoryData> field) {
        final TransactionType selectedType = field.value!.type;
        final List<Widget> conditionalSourceAccountField =
            selectedType == TransactionType.incoming ||
                    selectedType == TransactionType.internalTransfer
                ? [
                    AccountPicker(
                      key: destinationAccountPickerKey,
                      label: 'Destination Account',
                      errorText: destinationAccountPickerErrorText,
                      onSelected: (value) => field.didChange(
                        field.value!.copyWithDestinationAccountId(value),
                      ),
                    )
                  ]
                : [];
        final List<Widget> conditionalDestinationAccountField =
            selectedType == TransactionType.outgoing ||
                    selectedType == TransactionType.internalTransfer
                ? [
                    AccountPicker(
                      key: sourceAccountPickerKey,
                      label: 'Source Account',
                      errorText: sourceAccountPickerErrorText,
                      onSelected: (value) => field.didChange(
                        field.value!.copyWithSourceAccountId(value),
                      ),
                    ),
                  ]
                : [];
        return Column(
          spacing: 16,
          children: <Widget>[
                TransactionTypePicker(
                  onSelectionChanged: (newSelection) =>
                      field.didChange(field.value!.copyWithType(newSelection)),
                  selection: field.value!.type,
                ),
              ] +
              conditionalSourceAccountField +
              conditionalDestinationAccountField +
              [
                TransactionCategoryPicker(
                  label: 'Category',
                  errorText: categoryPickerErrorText,
                  onSelected: (value) =>
                      field.didChange(field.value?.copyWithCategoryId(value)),
                ),
              ],
        );
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        // just in case. though i don't see where this might be needed
        if (value == null) return "A value is required";

        // global error for this widget. will use this to set an error string.
        // note that the error string for this widget will never be visible.
        // Instead, the error strings on individual children of this widget
        // will be visible
        bool error = false;

        final bool wantSource = value.type == TransactionType.outgoing ||
            value.type == TransactionType.internalTransfer;
        if (wantSource && value.sourceAccountId == null) {
          setSourceAccountPickerErrorText('Please select a source account.');
          error = true;
        }

        final bool wantDestination = value.type == TransactionType.incoming ||
            value.type == TransactionType.internalTransfer;
        if (wantDestination && value.destinationAccountId == null) {
          setDestinationAccountPickerErrorText(
              'Please select a destination account');
          error = true;
        }

        if (value.categoryId != null) {
          final categoryType =
              Provider.of<AccountNotifier>(context, listen: false)
                  .categories
                  .where(
                    (element) => element.id == value.categoryId,
                  )
                  .firstOrNull
                  ?.type;
          if (categoryType == null) {
            error = true;
            setCategoryPickerErrorText("Invalid category selected.");
          } else if (categoryType != value.type) {
            error = true;
            setCategoryPickerErrorText(
              "Transaction is currently being set as type:${value.type} while "
              "the selected category is of type $categoryType. Please select a "
              "category of matching type",
            );
          }
        }

        return error ? "Required fields were not provided" : null;
      },
      initialValue: TransactionAccountAndCategoryData(
        type: TransactionType.outgoing,
        sourceAccountId: null,
        destinationAccountId: null,
        categoryId: null,
      ),
      onSaved: widget.onSaved,
    );
  }
}

class TransactionAccountAndCategoryData {
  final TransactionType type;
  final int? sourceAccountId;
  final int? destinationAccountId;
  final int? categoryId;

  const TransactionAccountAndCategoryData({
    required this.type,
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.categoryId,
  });

  TransactionAccountAndCategoryData copyWithType(TransactionType newType) =>
      TransactionAccountAndCategoryData(
          type: newType,
          sourceAccountId: sourceAccountId,
          destinationAccountId: destinationAccountId,
          categoryId: categoryId);

  TransactionAccountAndCategoryData copyWithSourceAccountId(
    int? newSourceAccountId,
  ) =>
      TransactionAccountAndCategoryData(
          type: type,
          sourceAccountId: newSourceAccountId,
          destinationAccountId: destinationAccountId,
          categoryId: categoryId);

  TransactionAccountAndCategoryData copyWithDestinationAccountId(
    int? newDestinationAccountId,
  ) =>
      TransactionAccountAndCategoryData(
        type: type,
        sourceAccountId: sourceAccountId,
        destinationAccountId: newDestinationAccountId,
        categoryId: categoryId,
      );

  TransactionAccountAndCategoryData copyWithCategoryId(
    final int? newCategoryId,
  ) =>
      TransactionAccountAndCategoryData(
          type: type,
          sourceAccountId: sourceAccountId,
          destinationAccountId: destinationAccountId,
          categoryId: newCategoryId);
}

class TransactionCategoryPicker extends StatelessWidget {
  final String label;
  final String? errorText;
  final ValueChanged<int?>? onSelected;
  final bool enabled;
  const TransactionCategoryPicker({
    super.key,
    required this.label,
    this.errorText,
    this.onSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      enabled: enabled,
      label: Text(label),
      enableFilter: true,
      enableSearch: true,
      requestFocusOnTap: false,
      errorText: errorText,
      width: 300,
      onSelected: onSelected,
      dropdownMenuEntries: Provider.of<AccountNotifier>(context)
          .categories
          .map((final category) => DropdownMenuEntry(
                value: category.id,
                label: category.name,
              ))
          .toList(),
    );
  }
}
