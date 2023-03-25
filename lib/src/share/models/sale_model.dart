class SaleModel {
  int? id;
  int clientId;
  int paymentMethod;
  double total;
  DateTime? date;

  SaleModel({
    this.id,
    required this.clientId,
    required this.paymentMethod,
    required this.total,
    this.date,
  });

  factory SaleModel.fromSQLite(Map map) => SaleModel(
        id: map['ID'],
        clientId: map['ID_CLIENTE'],
        paymentMethod: map['ID_FORMA_PAGAMENTO'],
        total: map['VALOR_TOTAL'].toDouble() ?? 0.0,
        date: DateTime.tryParse(map['DATA']),
      );

  static List<SaleModel> fromSQLiteList(List list) => list.map((e) => SaleModel.fromSQLite(e)).toList();

  List toSQLiteInsert() => [
    clientId,
    paymentMethod,
    total,
    date.toString(),
  ];

  List toSQLiteUpdate() => [
    clientId,
    paymentMethod,
    total,
    date.toString(),
    id,
  ];

  factory SaleModel.empty() => SaleModel(
    id: null,
    clientId: 0,
    paymentMethod: 0,
    total: 0,
    date: DateTime.now(),
  );



}
