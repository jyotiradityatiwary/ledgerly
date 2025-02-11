import 'package:flutter/material.dart';

class LoadingScreen<T> extends StatefulWidget {
  final String label;
  final Future<T> future;
  final void Function(T)? onCompleted;
  final void Function(dynamic)? onError;
  const LoadingScreen({
    super.key,
    this.label = "Loading...",
    required this.future,
    this.onCompleted,
    this.onError,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    widget.future.then(
      (final value) {
        if (context.mounted) Navigator.of(context).pop();
        widget.onCompleted?.call(value);
      },
      onError: (final error) {
        if (context.mounted) Navigator.of(context).pop();
        widget.onError?.call(error);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox.fromSize(
              size: Size.fromHeight(20),
            ),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}
