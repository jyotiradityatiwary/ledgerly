import 'dart:io';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:ledgerly/services/database_manager.dart';
import 'package:ledgerly/services/preference_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String databseeFileName = "db.sqlite3";
const String preferencesFileName = 'preferences.json';
const String appDirName = 'ledgerly';

Future<String> getAppDirPath() async {
  final String documentsDirectoryPath =
      (await getApplicationDocumentsDirectory()).path;
  final String appDirPath = p.join(documentsDirectoryPath, appDirName);
  return appDirPath;
}

/// Handles initialization of this app. Call this with `await` keyword from the main function.
Future<void> initializeApp() async {
  // create app directory if not present
  final String appDirPath = await getAppDirPath();
  if (!Directory(appDirPath).existsSync()) {
    Directory(appDirPath).createSync(recursive: true);
    developer.log("App Directory Created");
  }

  initializeDatabase(path: p.join(appDirPath, 'db.sqlite3'));
  await initializePreferencesService();

  developer.log("App initialized");
}

/// Frees up resources and closes open files / databases.
Future<AppExitResponse> disposeApp() async {
  closeDatabase();
  developer.log("Exiting gracefully");
  return AppExitResponse.exit;
}
