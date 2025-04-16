import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledgerly/views/app_initializer.dart';
import 'package:dynamic_color/dynamic_color.dart';

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
    return DynamicColorBuilder(
      builder: (
        final ColorScheme? lightDynamic,
        final ColorScheme? darkDynamic,
      ) {
        final lightTheme = lightDynamic == null
            ? ThemeData.light()
            : ThemeData(
                colorScheme: lightDynamic,
                brightness: Brightness.light,
              );
        final darkTheme = darkDynamic == null
            ? ThemeData.dark()
            : ThemeData(
                colorScheme: darkDynamic,
                brightness: Brightness.dark,
              );
        return MaterialApp(
          title: 'Ledgerly',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: AppInitializer(),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
