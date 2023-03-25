import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqfl_windows/src/share/dao/payment_method_dao.dart';
import 'package:flutter_sqfl_windows/src/share/entity/googlescipt_stock_product_entity.dart';
import 'package:flutter_sqfl_windows/src/share/models/payment_method_model.dart';
import 'package:flutter_sqfl_windows/src/share/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dao/provider_dao.dart';
import 'dao/sql.dart';
import 'entity/googlescript_purchase_entity.dart';
import 'models/provider_model.dart';
import 'services/connection_sqlite_service.dart';
import 'sheet_datasource.dart';

class Mock {
  final ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async => await _connection.db;

  Future<void> clearMocks() async {
    Database db = await _getDatabase();
    int result = await db.rawDelete(ConnectionSQL.clearAllTables());
    if (result > 0) {
      debugPrint("limpas");
    }
  }

  Future<void> insertMocks() async {
    Database db = await _getDatabase();
    int result = await db.rawInsert(ConnectionSQL.populateClient());
    if (result > 0) debugPrint("Cliente populado");
    result = await db.rawInsert(ConnectionSQL.populatePaymentMethod());
    if (result > 0) debugPrint("Forma de pagamento populada");
    // result = await db.rawInsert(ConnectionSQL.populateProduct());
    // if (result > 0) debugPrint("Produto populado");
    result = await db.rawInsert(ConnectionSQL.populateProvider());
    if (result > 0) debugPrint("Fornecedor populado");
    result = await db.rawInsert(ConnectionSQL.populateSale());
    if (result > 0) debugPrint("Venda populada");
    result = await db.rawInsert(ConnectionSQL.populateSaleProduct());
    if (result > 0) debugPrint("Item de venda populado");
    result = await db.rawInsert(ConnectionSQL.populatePurchase());
    if (result > 0) debugPrint("Compra populada");
    result = await db.rawInsert(ConnectionSQL.populatePurchaseProduct());
    if (result > 0) debugPrint("Item de compra populado");
  }

  Future<void> syncStock() async {
    Database db = await _getDatabase();
    ProviderDao providerDao = ProviderDao();
    PaymentMethodDao paymentMethodDao = PaymentMethodDao();
    Dio dio = Dio();
    try {
      Response response_stock_in = await dio.get(URL_ESTOQUE_ENTRADA);
      List<GoogleScriptStockProductEntity> list = response_stock_in.data.map<GoogleScriptStockProductEntity>((item) => GoogleScriptStockProductEntity.fromJson(item)).toList();
      List<ProductModel> products = list.map<ProductModel>((item) => ProductModel.fromGoogleScriptStockProductEntity(item)).toList();
      await db.rawInsert(ConnectionSQL.populateProductFromList(products));

      Response response_purchase = await dio.get(URL_COMPRA);
      List<GoogleScriptPurchaseEntity> list_purchase = response_purchase.data.map<GoogleScriptPurchaseEntity>((item) => GoogleScriptPurchaseEntity.fromJson(item)).toList();
      for (GoogleScriptPurchaseEntity item in list_purchase) {
        ProviderModel? provider = await providerDao.selectByName(item.nome_fornecedor ?? "Sem nome");
        PaymentMethodModel? paymentMethod = await paymentMethodDao.selectByName(item.forma_pagamento ?? "Sem nome");
        await db.rawInsert(ConnectionSQL.addPurchase(), [provider.id, paymentMethod.id, item.valor_total, item.data?.toIso8601String()]);
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }
}
