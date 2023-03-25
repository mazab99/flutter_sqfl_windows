import 'package:flutter_sqfl_windows/src/share/dao/sql.dart';
import 'package:sqflite/sqflite.dart';

import '../models/buy_model.dart';
import '../models/purchase_product_model.dart';
import '../services/connection_sqlite_service.dart';

class PurchaseDao{
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async => await _connection.db;

  Future<PurchaseModel> insert(PurchaseModel purchase) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ConnectionSQL.addPurchase(), purchase.toSQLiteInsert());
      purchase.id = id;
      return purchase;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> update(PurchaseModel purchase) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawUpdate(ConnectionSQL.updatePurchase(), purchase.toSQLiteUpdate());
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<PurchaseModel>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectAllPurchase());
      return PurchaseModel.fromSQLiteList(result);
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> delete(PurchaseModel purchase) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawDelete(ConnectionSQL.deletePurchase(), [purchase.id]);
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<PurchaseModel> selectById(int id) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectPurchaseById(), [id]);
      return PurchaseModel.fromSQLite(result.first);
    } catch (error) {
      throw Exception();
    }
  }


  Future<bool> insertPurchaseProduct(PurchaseProductModel product) async {
    try {
      Database db = await _getDatabase();
      await db.rawInsert(ConnectionSQL.addPurchaseProduct(), product.toSQLiteInsert());
      return true;
    } catch (error) {
      throw Exception();
    }
  }
}