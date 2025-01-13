import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerly/services/database_service.dart';
import 'package:ledgerly/services/user_service.dart';
import 'package:path/path.dart' as p;

void main() {
  final dbPath = p.join('build', 'test_db.sqlite3');
  WidgetsFlutterBinding.ensureInitialized();
  test('Can we initialize, close and delete the databse?', () {
    initializeDatabase(path: dbPath);
    expect(
      File(dbPath).existsSync(),
      isTrue,
      reason: 'Database file should exist after initialization.',
    );
    expect(
      db,
      isNotNull,
      reason: 'Database object should be assigned.',
    );
    expect(
      () => deleteDatabase(),
      throwsA(isA<PathAccessException>()),
      reason:
          'Database should be open, and trying to delete open file should throw exception.',
    );
    closeDatabase();
    expect(
      () => deleteDatabase(),
      returnsNormally,
      reason:
          'Should be able to delete the file now that the database is closed.',
    );
    expect(
      File(dbPath).existsSync(),
      isFalse,
      reason: 'Database file should not exist after database deletion.',
    );
  });

  group('User Service', () {
    setUpAll(() {
      if (File(dbPath).existsSync()) deleteDatabase();
      initializeDatabase(path: dbPath);
    });

    tearDownAll(() {
      closeDatabase();
      deleteDatabase();
    });

    test('Can we register and retrieve users to/from database?', () {
      const int numOfUsers = 4;
      assert(numOfUsers > 0);
      int? previousId;
      for (final int i in Iterable.generate(numOfUsers)) {
        final name = 'User $i';
        final precision = 4 + (i % 2);
        const currencies = ['\$', '₹', 'EUR'];
        final currency = currencies[i % currencies.length];
        final int id = registerUser(
          name: name,
          currencyPrecision: precision,
          currency: currency,
        );
        if (previousId != null) {
          expect(
            id,
            equals(previousId + 1),
            reason: 'User ID should auto increment starting.',
          );
        }
        previousId = id;
        final User user = getUser(id);
        expect(
          [
            user.id,
            user.name,
            user.currencyPrecision,
            user.currency,
            user.cloudUser,
          ],
          equals([id, name, precision, currency, null]),
          reason: 'Returned values should match inserted values',
        );
      }

      final userIds = getAllUserIds();
      expect(
        userIds.length,
        equals(numOfUsers),
        reason:
            'Number of (returned) user id-s should equal the number of users we inserted.',
      );

      final users = getAllUsers();
      expect(
        users.map((user) => user.id).toList(),
        equals(userIds),
        reason:
            'ID of returned users should match the list of ids returned by the getAllUserIDs function.',
      );

      expect(
        () {
          deleteUser(id: previousId!);
        },
        returnsNormally,
        reason: 'This user exists so deletion should occur normally.',
      );
      expect(getAllUserIds().length, numOfUsers - 1,
          reason:
              'Number of users in databse should decrease by one on deletion.');
      expect(
        () {
          deleteUser(id: previousId!);
        },
        throwsAssertionError,
        reason:
            'This user is already deleted so function should fail assertion.',
      );
    });

    test('Update User', () {
      const String name = "User";
      const int currencyPrecision = 4;
      const String currency = "EUR";
      final int id = registerUser(
          name: name, currencyPrecision: currencyPrecision, currency: currency);
      expect(
          getUser(id).toListWithoutId(),
          equals(User(
            id: id,
            name: name,
            currencyPrecision: currencyPrecision,
            currency: currency,
          ).toListWithoutId()));
    });
  });
}
