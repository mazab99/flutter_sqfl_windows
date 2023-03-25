import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../dao/sql.dart';
import 'package:path/path.dart';

class ConnectionSQLiteService {
  ConnectionSQLiteService._();

  static ConnectionSQLiteService? _instance;

  static ConnectionSQLiteService get instance {
    _instance ??= ConnectionSQLiteService._();
    return _instance!;
  }

  static const String _databaseName = 'project.db';
  static const int _databaseVersion = 1;
  Database? _db;

  Future<Database> get db => openDatabase();

  Future<Database> openDatabase() async {
    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, _databaseName);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    _db ??= await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: _databaseVersion,
          onCreate: _onCreate,
        ));
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    db.transaction((reference) async => reference.execute(ConnectionSQL.createDatabase));
  }
}
