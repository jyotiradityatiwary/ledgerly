import 'package:flutter/material.dart';
import 'package:ledgerly/view_models/login_screen.dart';
import 'package:provider/provider.dart';

class _FormData {
  String name = "";
  String currency = "";

  void submit(
    final BuildContext context,
    final GlobalKey<FormState> formKey,
  ) {
    if (!formKey.currentState!.validate()) return;

    // if validated
    formKey.currentState!.save();
    Provider.of<LoginScreenViewModel>(context, listen: false).addUser(
      name: name,
      currency: currency,
    );
    Navigator.of(context).pop();
  }
}

class AddUserScreen extends StatelessWidget {
  AddUserScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _formData = _FormData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Add a new user',
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
                  _CurrencyFormField(formData: _formData, formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrencyFormField extends StatelessWidget {
  const _CurrencyFormField({
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
        label: Text("Enter Currency Symbol"),
      ),
      onFieldSubmitted: (final String _) => _formData.submit(context, _formKey),
      validator: (value) => value == null || value.isEmpty
          ? "Please enter a currency symbol"
          : null,
      onSaved: (newValue) {
        _formData.currency = newValue!;
      },
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
