import 'package:flutter/material.dart';
import 'package:ledgerly/services/app_manager.dart';
import 'package:ledgerly/views/login_checker/view.dart';
import 'package:ledgerly/views/spash_screen.dart';

/// Handles initialization and disposal of the app
class AppInitializer extends StatefulWidget {
  const AppInitializer({
    super.key,
  });

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onExitRequested: disposeApp,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeApp(),
      builder: (context, AsyncSnapshot snapshot) =>
          switch (snapshot.connectionState) {
        ConnectionState.done ||
        ConnectionState.none =>
          snapshot.hasError ? Text("error: ${snapshot.error}") : LoginChecker(),
        ConnectionState.waiting || ConnectionState.active => SplashScreen(),
      },
    );
  }
}
