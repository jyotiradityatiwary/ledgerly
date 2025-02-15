import 'dart:io';

import 'package:ledgerly/services/app_manager.dart';
import 'package:path/path.dart' as p;

final basePath = p.join(Directory.systemTemp.path, appDirName);
// final basePath = 'build';
String getUniqueDbPath() => p.join(basePath, 'test_db.sqlite3');

void main() {
  // // TODO: fix testing
  // // hint: use in-memory databsess
  // test('Can we initialize, close and delete the databse?', () {
  //   final dbPath = getUniqueDbPath();
  //   if (File(dbPath).existsSync()) File(dbPath).deleteSync();
  //   initializeDatabase(path: dbPath);
  //   expect(
  //     File(dbPath).existsSync(),
  //     isTrue,
  //     reason: 'Database file should exist after initialization.',
  //   );
  //   expect(
  //     dbHandle,
  //     isNotNull,
  //     reason: 'Database object should be assigned.',
  //   );
  //   expect(
  //     () => deleteDatabase(),
  //     throwsA(isA<PathAccessException>()),
  //     reason:
  //         'Database should be open, and trying to delete open file should throw exception.',
  //   );
  //   closeDatabase();
  //   expect(
  //     () => dbHandle,
  //     throwsA(isA<DatabaseNotOpenError>()),
  //     reason: 'Database is closed so handle should not be accessible.',
  //   );
  //   expect(
  //     () => userCrudService.containsId(1),
  //     throwsA(isA<DatabaseNotOpenError>()),
  //     reason:
  //         'After closing the databse handle should not be available even from wrapper services.',
  //   );
  //   // TODO: can't delete databse because sqlite3 apparently needs garbage collection to actually release the file handles
  //   // similar problem in java: https://stackoverflow.com/questions/8511901/system-data-sqlite-close-not-releasing-database-file
  //   // .. which can be fixed with `System.gc();`
  //   // expect(
  //   //   () => deleteDatabase(),
  //   //   returnsNormally,
  //   //   reason:
  //   //       'Should be able to delete the file now that the database is closed. Note that this exception may also be caused if the path or file is open in another process, for example a File Explorer or a Terminal, or even one of the other unit tests (if they for some reason share the same file path)',
  //   // );
  //   expect(
  //     File(dbPath).existsSync(),
  //     isFalse,
  //     reason: 'Database file should not exist after database deletion.',
  //   );
  // });

  // group('User Service', () {
  //   setUp(() {
  //     final dbPath = getUniqueDbPath();
  //     if (File(dbPath).existsSync()) File(dbPath).deleteSync();
  //     initializeDatabase(path: dbPath);
  //   });

  //   tearDown(() async {
  //     closeDatabase();
  //     await Future.delayed(const Duration(seconds: 3));
  //     deleteDatabase();
  //   });

  //   test('Can we register and retrieve users to/from database?', () {
  //     const int numOfUsers = 4;
  //     assert(numOfUsers > 0);
  //     int? previousId;
  //     for (final int i in Iterable.generate(numOfUsers)) {
  //       final name = 'User $i';
  //       final precision = 4 + (i % 2);
  //       const currencies = ['\$', '₹', 'EUR'];
  //       final currency = currencies[i % currencies.length];
  //       final int id = userCrudService.register(
  //         name: name,
  //         currencyPrecision: precision,
  //         currency: currency,
  //       );
  //       if (previousId != null) {
  //         expect(
  //           id,
  //           equals(previousId + 1),
  //           reason: 'User ID should auto increment starting.',
  //         );
  //       }
  //       previousId = id;
  //       final User user = userCrudService.getById(id);
  //       expect(
  //         [
  //           user.id,
  //           user.name,
  //           user.currencyPrecision,
  //           user.currency,
  //           user.cloudUser,
  //         ],
  //         equals([id, name, precision, currency, null]),
  //         reason: 'Returned values should match inserted values',
  //       );
  //     }

  //     final userIds = userCrudService.getAllIds();
  //     expect(
  //       userIds.length,
  //       equals(numOfUsers),
  //       reason:
  //           'Number of (returned) user id-s should equal the number of users we inserted.',
  //     );

  //     final users = userCrudService.getAll();
  //     expect(
  //       users.map((user) => user.id).toList(),
  //       equals(userIds),
  //       reason:
  //           'ID of returned users should match the list of ids returned by the getAllUserIDs function.',
  //     );

  //     expect(
  //       () {
  //         userCrudService.delete(previousId!);
  //       },
  //       returnsNormally,
  //       reason: 'This user exists so deletion should occur normally.',
  //     );
  //     expect(userCrudService.getAllIds().length, numOfUsers - 1,
  //         reason:
  //             'Number of users in databse should decrease by one on deletion.');
  //     expect(
  //       userCrudService.containsId(previousId!),
  //       isFalse,
  //       reason: 'This user is deleted so it must not be present.',
  //     );
  //   });

  //   test('Update User', () {
  //     const String name = "User";
  //     const int currencyPrecision = 4;
  //     const String currency = "EUR";
  //     final int id = userCrudService.register(
  //         name: name, currencyPrecision: currencyPrecision, currency: currency);
  //     expect(
  //         userSchema.itemToListWithoutId(userCrudService.getById(id)),
  //         equals(userSchema.itemToListWithoutId(User(
  //           id: id,
  //           name: name,
  //           currencyPrecision: currencyPrecision,
  //           currency: currency,
  //           cloudUser: null,
  //         ))));
  //   });
  // });
}
