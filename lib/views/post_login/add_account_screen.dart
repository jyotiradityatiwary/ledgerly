import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:provider/provider.dart';

class _FormData {
  String name = '';
  int initialBalance = 0;
  String? description;

  void submit(
    final BuildContext context,
    final GlobalKey<FormState> formKey,
  ) {
    if (!formKey.currentState!.validate()) return;

    // if validated
    formKey.currentState!.save();
    Provider.of<AccountNotifier>(context, listen: false).addAccount(
      name: name,
      user: Provider.of<PreferencesNotifier>(context, listen: false).user!,
      initialBalance: initialBalance,
      description: description,
    );
    Navigator.of(context).pop();
  }
}

class AddAccountScreen extends StatelessWidget {
  AddAccountScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _formData = _FormData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add a new account',
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _formData.submit(context, _formKey),
          label: Text("Save"),
          icon: Icon(Icons.save),
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  _NameFormField(formData: _formData, formKey: _formKey),
                  _InitialBalanceFormField(
                      formData: _formData, formKey: _formKey),
                  _DescriptionFormField(formData: _formData, formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameFormField extends StatelessWidget {
  const _NameFormField({
    required _FormData formData,
    required GlobalKey<FormState> formKey,
  })  : _formData = formData,
        _formKey = formKey;

  final _FormData _formData;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Enter Name"),
      ),
      autofocus: true,
      onFieldSubmitted: (final String _) => _formData.submit(context, _formKey),
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter a name" : null,
      onSaved: (newValue) {
        _formData.name = newValue!;
      },
    );
  }
}

class _InitialBalanceFormField extends StatelessWidget {
  _InitialBalanceFormField({
    required _FormData formData,
    required GlobalKey<FormState> formKey,
  })  : _formData = formData,
        _formKey = formKey;

  final _FormData _formData;
  final GlobalKey<FormState> _formKey;

  final RegExp balanceRegex = RegExp(r'^(\+|-)?(\d*)\.?(\d*)$');

  @override
  Widget build(BuildContext context) {
    final maxPrecision =
        Provider.of<PreferencesNotifier>(context).user!.currencyPrecision;
    final maxInputPrecision = maxPrecision - 1;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Provider.of<PreferencesNotifier>(context).user!.currency,
          ),
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Enter Initial Balance"),
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onFieldSubmitted: (final String _) =>
                _formData.submit(context, _formKey),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter an initial balance.";
              }
              final groups = balanceRegex.firstMatch(value);
              if (groups == null) return "Please enter a valid number";
              if ((groups[3] ?? '').length > maxInputPrecision) {
                return 'Maximum decimal precision allowed is $maxInputPrecision';
              }
              return null;
            },
            onSaved: (newValue) {
              final groups = balanceRegex.firstMatch(newValue!)!;
              final isNegative = groups[1] != null && groups[1] == '-';
              final sign = isNegative ? -1 : 1;
              final integerPart = groups[2] == null || groups[2] == ''
                  ? 0
                  : int.parse(groups[2]!);
              final fractionalPart = groups[3] == null || groups[3] == ''
                  ? 0
                  : int.parse(groups[3]!);
              final unsignedBalance =
                  integerPart * 10 ^ maxInputPrecision + fractionalPart;
              final int balance = sign * unsignedBalance;
              _formData.initialBalance = balance;
            },
          ),
        ),
        IconButton(
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
      ],
    );
  }
}

class _DescriptionFormField extends StatelessWidget {
  const _DescriptionFormField({
    required _FormData formData,
    required GlobalKey<FormState> formKey,
  })  : _formData = formData,
        _formKey = formKey;

  final _FormData _formData;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        label: Text("Enter Description (Optional)"),
      ),
      onFieldSubmitted: (final String _) => _formData.submit(context, _formKey),
      onSaved: (newValue) {
        _formData.description = newValue;
      },
      minLines: 2,
      maxLines: 4,
    );
  }
}
