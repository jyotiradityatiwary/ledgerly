import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/login_notifier.dart';
import 'package:ledgerly/services/crud_services.dart';
import 'package:ledgerly/views/reusable/form_fields.dart';
import 'package:provider/provider.dart';

class _FormData {
  Account? sourceAccount;
  Account? destinationAccount;
  int amount = 0;
  String summary = "";
  String? description;
  DateTime dateTime = DateTime.now();
  TransactionCategory? category;

  void submit(
    final BuildContext context,
    final GlobalKey<FormState> formKey,
  ) {
    if (!formKey.currentState!.validate()) return;

    // if validated
    formKey.currentState!.save();
    Provider.of<AccountNotifier>(
      context,
      listen: false,
    ).createTransaction(
      sourceAccount: sourceAccount,
      destinationAccount: destinationAccount,
      amount: amount,
      summary: summary,
      dateTime: dateTime,
      description: description,
      category: category,
    );
    Navigator.of(context).pop();
  }
}

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _formData = _FormData();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginNotifier>(context).user!;

    final List<Widget> children = [
      NameFormField(
        label: 'Summary',
        onFieldSubmitted: (value) => _formData.submit(context, _formKey),
        onSaved: (newValue) => _formData.summary = newValue,
      ),
      CurrencyInputFormField(
        label: 'Amount',
        onSaveAmount: (amount) {
          _formData.amount = amount;
        },
        onFieldSubmitted: (value) {
          _formData.submit(context, _formKey);
        },
        user: user,
      ),
      TransactionAccountAndCategoryFormField(
        onSaved: (newValue) {
          assert(newValue != null);
          _formData.sourceAccount = newValue!.sourceAccountId == null
              ? null
              : accountCrudService.getById(newValue.sourceAccountId!);
          _formData.destinationAccount = newValue.destinationAccountId == null
              ? null
              : accountCrudService.getById(newValue.destinationAccountId!);
          _formData.category = newValue.categoryId == null
              ? null
              : transactionCategoryCrudService.getById(newValue.categoryId!);
        },
      ),
      DateInputFormField(
        label: 'Date',
        onSaved: (newDate) => _formData.dateTime = newDate,
        initialValue: _formData.dateTime,
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
            'Add a new transaction',
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
                padding: EdgeInsets.only(bottom: 80),
                itemBuilder: (context, index) => children[index],
                itemCount: children.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
