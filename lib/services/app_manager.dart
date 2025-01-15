import 'dart:io';

import 'package:ledgerly/constants.dart';
import 'package:ledgerly/services/database_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String databseeFileName = "db.sqlite3";
const String preferencesFileName = 'preferences.json';

Future<String> getAppDirPath() async {
  final String documentsDirectoryPath =
      (await getApplicationCacheDirectory()).path;
  final String appDirPath = p.join(documentsDirectoryPath, appDirName);
  return appDirPath;
}

/// Handles initialization of this app. Call this with `await` keyword from the main function.
Future<void> initializeApp() async {
  // create app directory if not present
  final String appDirPath = await getAppDirPath();
  if (!Directory(appDirPath).existsSync()) {
    Directory(appDirPath).createSync(recursive: true);
  }

  initializeDatabase(path: p.join(appDirPath, 'db.sqlite3'));
}

/// Frees up resources and closes open files / databases.
Future<void> disposeApp() async {
  closeDatabase();
}
