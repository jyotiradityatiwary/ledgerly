import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/preferences_notifier.dart';
import 'package:ledgerly/views/reusable/form_fields.dart';
import 'package:provider/provider.dart';

class _FormData {
  String name;
  int initialBalance;
  String? description;

  _FormData({
    required this.name,
    required this.initialBalance,
    this.description,
  });
}

class AddOrModifyAccountScreen extends StatelessWidget {
  AddOrModifyAccountScreen({super.key, Account? account})
      : _formData = _FormData(
          name: account?.name ?? '',
          initialBalance: account?.initialBalance ?? 0,
          description: account?.description,
        ),
        _originalId = account?.id;

  final int? _originalId;
  final _formKey = GlobalKey<FormState>();
  final _FormData _formData;

  @override
  Widget build(BuildContext context) {
    void submit() {
      if (!_formKey.currentState!.validate()) return;

      // if validated
      _formKey.currentState!.save();
      Provider.of<AccountNotifier>(context, listen: false).addOrModifyAccount(
        originalId: _originalId,
        name: _formData.name,
        user: Provider.of<PreferencesNotifier>(context, listen: false).user!,
        initialBalance: _formData.initialBalance,
        description: _formData.description,
      );
      Navigator.of(context).pop();
    }

    final user = Provider.of<PreferencesNotifier>(context).user!;
    final List<Widget> children = [
      NameFormField(
        label: 'Account Name',
        onFieldSubmitted: (value) => submit(),
        onSaved: (newValue) => _formData.name = newValue,
        autofocus: true,
        initialValue: _formData.name,
      ),
      CurrencyInputFormField(
        label: 'Initial Balance',
        onSaveAmount: (newAmount) => _formData.initialBalance = newAmount,
        onFieldSubmitted: (value) => submit(),
        currencyPrecision: user.currencyPrecision,
        currency: user.currency,
        initialValue: _formData.initialBalance,
      ),
      DescriptionFormField(
        label: 'Description',
        onFieldSubmitted: (value) => submit(),
        onSaved: (newValue) => _formData.description = newValue,
        initialValue: _formData.description,
      ),
    ];
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _originalId == null ? 'Add a new account' : "Edit account",
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => submit(),
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
