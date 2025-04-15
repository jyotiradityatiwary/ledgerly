import 'package:flutter/material.dart';
import 'package:ledgerly/model/data_classes.dart';
import 'package:ledgerly/notifiers/user_notifier.dart';
import 'package:ledgerly/views/reusable/form_fields.dart';
import 'package:provider/provider.dart';

class _FormData {
  String name;
  String currency;

  _FormData({
    required this.name,
    required this.currency,
  });
}

/// Form for creating a new user or modifying an existing user
///
/// If [user] is provided, the form will serve to modify that user, otherwise
/// the form will create a new user upon submission.
class AddOrModifyUserScreen extends StatelessWidget {
  AddOrModifyUserScreen({
    super.key,
    User? user,
  })  : _originalUserId = user?.id,
        _formData = _FormData(
          name: user?.name ?? '',
          currency: user?.currency ?? '',
        );

  final int? _originalUserId;
  final _FormData _formData;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void submit() {
      if (!_formKey.currentState!.validate()) return;

      // if validated
      _formKey.currentState!.save();

      final viewModel = Provider.of<UserNotifier>(context, listen: false);
      viewModel.createOrModifyUser(
        originalUserId: _originalUserId,
        name: _formData.name,
        currency: _formData.currency,
      );

      Navigator.of(context).pop();
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add a new user',
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: submit,
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
                  NameFormField(
                    label: 'Name',
                    onFieldSubmitted: (value) => submit(),
                    onSaved: (newValue) => _formData.name = newValue,
                    autofocus: true,
                    initialValue: _formData.name,
                  ),
                  NameFormField(
                    label: 'Currency',
                    onFieldSubmitted: (value) => submit(),
                    onSaved: (newValue) => _formData.currency = newValue,
                    initialValue: _formData.currency,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
