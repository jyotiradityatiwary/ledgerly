import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledgerly/views/app_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ledgerly',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: AppInitializer(),
      themeMode: ThemeMode.system,
    );
  }
}
