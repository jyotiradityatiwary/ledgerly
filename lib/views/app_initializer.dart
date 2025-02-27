import 'package:flutter/material.dart';
import 'package:ledgerly/services/app_manager.dart';
import 'package:ledgerly/views/error_screen.dart';
import 'package:ledgerly/views/login_checker.dart';
import 'package:ledgerly/views/loading_screen.dart';

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
    return LoadingScreen<void>(
      future: initializeApp(),
      label: "Initializing App",
      onCompleted: (void _) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginChecker(),
          ),
        );
      },
      onError: (_) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ErrorScreen(error: 'Failed to inilialize app'),
          ),
        );
      },
    );
  }
}
