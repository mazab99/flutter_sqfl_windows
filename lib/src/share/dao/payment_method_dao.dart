import 'package:flutter_sqfl_windows/src/share/dao/sql.dart';
import 'package:sqflite/sqflite.dart';

import '../models/payment_method_model.dart';
import '../services/connection_sqlite_service.dart';

class PaymentMethodDao{
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async => await _connection.db;

  Future<PaymentMethodModel> insert(PaymentMethodModel paymentMethod) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ConnectionSQL.addPaymentMethod(), paymentMethod.toSQLiteInsert());
      paymentMethod.id = id;
      return paymentMethod;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> update(PaymentMethodModel paymentMethod) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawUpdate(ConnectionSQL.updatePaymentMethod(), paymentMethod.toSQLiteUpdate());
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<PaymentMethodModel>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectAllPaymentMethod());
      return PaymentMethodModel.fromSQLiteList(result);
    } catch (error) {
      throw Exception();
    }
  }

  Future<PaymentMethodModel> selectByName(String name) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectPaymentMethodByName(), [name]);
      return PaymentMethodModel.fromSQLite(result.first);
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> delete(PaymentMethodModel paymentMethod) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawDelete(ConnectionSQL.deletePaymentMethod(), [paymentMethod.id]);
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<PaymentMethodModel> selectById(int id) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectPaymentMethodById(), [id]);
      return PaymentMethodModel.fromSQLite(result.first);
    } catch (error) {
      throw Exception();
    }
  }
}