import 'package:flutter_sqfl_windows/src/share/models/provider_model.dart';
import '../services/connection_sqlite_service.dart';
import 'package:sqflite/sqflite.dart';
import 'sql.dart';

class ProviderDao{
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async => await _connection.db;

  Future<ProviderModel> insert(ProviderModel provider) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ConnectionSQL.addProvider(), provider.toSQLiteInsert());
      provider.id = id;
      return provider;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> update(ProviderModel provider) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawUpdate(ConnectionSQL.updateProvider(), provider.toSQLiteUpdate());
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> delete(ProviderModel provider) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawDelete(ConnectionSQL.deleteProvider(), provider.toSQLiteDelete());
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<ProviderModel> selectByName(String name) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectProviderByName(), [name]);
      return ProviderModel.fromSQLite(result.first);
    } catch (error) {
      throw Exception();
    }
  }

  Future<ProviderModel> selectById(int id) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectProviderById(), [id]);
      return ProviderModel.fromSQLite(result.first);
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<ProviderModel>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map<String, dynamic>> result = await db.rawQuery(ConnectionSQL.selectAllProvider());
      return result.map((e) => ProviderModel.fromSQLite(e)).toList();
    } catch (error) {
      throw Exception();
    }
  }


}