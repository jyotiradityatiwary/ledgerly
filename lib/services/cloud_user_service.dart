class CloudUser {
  static const String createTableSql = '''
CREATE TABLE CloudUsers (
  cloud_user_id INTEGER PRIMARY KEY,
  server_address TEXT NOT NULL,
  identifier TEXT NOT NULL,
  last_sync_date_time INTEGER NOT NULL,
  login_expiry_date_time INTEGER NOT NULL
);
''';
  final int id;
  final String serverAddress;
  final String identifier;
  final DateTime lastSyncDateTime;
  final DateTime loginExpiryDateTime;

  const CloudUser({
    required this.id,
    required this.serverAddress,
    required this.identifier,
    required this.lastSyncDateTime,
    required this.loginExpiryDateTime,
  });
}
