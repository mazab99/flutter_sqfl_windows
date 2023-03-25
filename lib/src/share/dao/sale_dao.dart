import 'package:flutter_sqfl_windows/src/share/dao/sql.dart';
import 'package:sqflite/sqflite.dart';

import '../models/sale_model.dart';
import '../services/connection_sqlite_service.dart';

class SaleDao{
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async => await _connection.db;

  Future<SaleModel> insert(SaleModel sale) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ConnectionSQL.addSale(), sale.toSQLiteInsert());
      sale.id = id;
      return sale;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> update(SaleModel sale) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawUpdate(ConnectionSQL.updateSale(), sale.toSQLiteUpdate());
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<SaleModel>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectAllSale());
      return SaleModel.fromSQLiteList(result);
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> delete(SaleModel sale) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawDelete(ConnectionSQL.deleteSale(), [sale.id]);
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }


}