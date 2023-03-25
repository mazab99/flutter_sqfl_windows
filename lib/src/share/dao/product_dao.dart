import 'package:flutter_sqfl_windows/src/share/dao/sql.dart';
import 'package:flutter_sqfl_windows/src/share/models/product_model.dart';
import 'package:flutter_sqfl_windows/src/share/models/sale_product_model.dart';
import '../services/connection_sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class ProductDao{
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async => await _connection.db;

  Future<ProductModel> insert(ProductModel product) async {
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert(ConnectionSQL.addProduct(), product.toSQLiteInsert());
      product.id = id;
      return product;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> update(ProductModel product) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawUpdate(ConnectionSQL.updateProduct(), product.toSQLiteListUpdate());
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<ProductModel>> selectAll() async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectAllProduct());
      return ProductModel.fromSQLiteList(result);
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> delete(ProductModel product) async {
    try {
      Database db = await _getDatabase();
      int result = await db.rawDelete(ConnectionSQL.deleteProduct(), [product.id]);
      return result > 0;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<SaleProductModel>> getProductFromSale(List<ProductModel>products , int idSale) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectSaleProductById(), [idSale]);
      List<SaleProductModel> saleProductModel = SaleProductModel.fromSQLiteList(result);
      SaleProductModel ret = saleProductModel.firstWhere((element) => element.id_venda == 1);
      return saleProductModel;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<ProductModel>> getProductFromPurchase(List<ProductModel> products, int idPurchase) async {
    try {
      Database db = await _getDatabase();
      List<Map> result = await db.rawQuery(ConnectionSQL.selectPurchaseProductById(), [idPurchase]);
      List<Map> resultProduct = await db.rawQuery(ConnectionSQL.selectProductById(), [result.first["ID_PRODUTO"]]);
      return ProductModel.fromSQLiteList(resultProduct);
    } catch (error) {
      throw Exception();
    }
  }

}