class SaleProductModel{
  int id_venda;
  int id_produto;
  double quantidade;
  double valor;

  SaleProductModel({
    required this.id_venda,
    required this.id_produto,
    required this.quantidade,
    required this.valor,
  });

  factory SaleProductModel.fromSQLite(Map map) => SaleProductModel(
    id_venda: map['ID_VENDA'],
    id_produto: map['ID_PRODUTO'],
    quantidade: map['QUANTIDADE'].toDouble() ?? 0.0,
    valor: map['VALOR'].toDouble() ?? 0.0,
  );

  static List<SaleProductModel> fromSQLiteList(List list) => list.map((e) => SaleProductModel.fromSQLite(e)).toList();

  List toSQLiteInsert() => [
    id_venda,
    id_produto,
    quantidade,
    valor,
  ];

  List toSQLiteUpdate() => [
    id_venda,
    id_produto,
    quantidade,
    valor,
  ];

  factory SaleProductModel.empty() => SaleProductModel(
    id_venda: 0,
    id_produto: 0,
    quantidade: 0,
    valor: 0,
  );

}