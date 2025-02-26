import 'package:flutter/material.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/views/reusable/form_fields.dart';
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
    final user = Provider.of<PreferencesNotifier>(context).user!;
    final List<Widget> children = [
      NameFormField(
        label: 'Account Name',
        onFieldSubmitted: (value) => _formData.submit(context, _formKey),
        onSaved: (newValue) => _formData.name = newValue,
      ),
      CurrencyInputFormField(
        label: 'Initial Balance',
        onSaveAmount: (newAmount) => _formData.initialBalance = newAmount,
        onFieldSubmitted: (value) => _formData.submit(context, _formKey),
        currencyPrecision: user.currencyPrecision,
        currency: user.currency,
      ),
      DescriptionFormField(
        label: 'Description',
        onFieldSubmitted: (value) => _formData.submit(context, _formKey),
        onSaved: (newValue) => _formData.description = newValue,
      ),
    ];
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
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => children[index],
                itemCount: children.length,
                separatorBuilder: (context, index) => SizedBox.fromSize(
                  size: Size.fromHeight(16),
                ),
                padding: EdgeInsets.only(bottom: 80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
