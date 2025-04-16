import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/notifiers/account_notifier.dart';
import 'package:ledgerly/notifiers/login_notifier.dart';
import 'package:ledgerly/views/reusable/form_fields.dart';
import 'package:provider/provider.dart';

class _FormData {
  String name;
  String? description;
  TransactionType type;

  _FormData({
    required this.name,
    required this.description,
    required this.type,
  });
}

class AddOrModifyCategoryScreen extends StatelessWidget {
  AddOrModifyCategoryScreen({
    super.key,
    TransactionCategory? category,
    TransactionType? initiallySelectedType,
  })  : _formData = _FormData(
          name: category?.name ?? "",
          description: category?.description,
          type: category?.type ??
              initiallySelectedType ??
              TransactionType.outgoing,
        ),
        _originalId = category?.id {
    // either initial category (to be modified) or a pre-selected type should
    // be specified but not both
    assert(category == null || initiallySelectedType == null);
  }

  final int? _originalId;
  final _formKey = GlobalKey<FormState>();
  final _FormData _formData;

  @override
  Widget build(BuildContext context) {
    void submit() {
      if (!_formKey.currentState!.validate()) return;

      // if validated
      _formKey.currentState!.save();
      Provider.of<AccountNotifier>(context, listen: false).addOrModifyCategory(
        originalId: _originalId,
        name: _formData.name,
        user: Provider.of<LoginNotifier>(context, listen: false).user!,
        type: _formData.type,
        description: _formData.description,
      );
      Navigator.of(context).pop();
    }

    void ignoreValueAndSubmit(String value) {
      submit();
    }

    final List<Widget> children = [
      NameFormField(
        label: "Category Name",
        onFieldSubmitted: ignoreValueAndSubmit,
        onSaved: (newValue) => _formData.name = newValue,
        autofocus: true,
        initialValue: _formData.name,
      ),
      TransactionTypeFormField(
        initialValue: _formData.type,
        onSaved: (newValue) => _formData..type = newValue,
      ),
      DescriptionFormField(
        label: "Description",
        onFieldSubmitted: ignoreValueAndSubmit,
        onSaved: (newValue) => _formData.description = newValue,
        initialValue: _formData.description,
      ),
    ];

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              _originalId == null ? "Add New Category" : "Modify Category"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: submit,
          label: Text("Save"),
          icon: Icon(Icons.save),
        ),
        body: Center(
            child: Container(
          constraints: BoxConstraints(maxWidth: 400.0),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => children[index],
            separatorBuilder: (context, index) => SizedBox.fromSize(
              size: Size.fromHeight(16.0),
            ),
            itemCount: children.length,
            padding: EdgeInsets.only(bottom: 80.0),
          ),
        )),
      ),
    );
  }
}
