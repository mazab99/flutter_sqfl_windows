class PaymentMethodModel {
  int? id;
  String name;

  PaymentMethodModel({this.id, required this.name});

  factory PaymentMethodModel.fromSQLite(Map map) => PaymentMethodModel(
        id: map['ID'],
        name: map['NOME'],
      );

  static List<PaymentMethodModel> fromSQLiteList(List list) => list.map((e) => PaymentMethodModel.fromSQLite(e)).toList();

  List toSQLiteInsert() => [
        name,
      ];

  List toSQLiteUpdate() => [
        name,
        id,
      ];


  factory PaymentMethodModel.empty() => PaymentMethodModel(
        id: null,
        name: '',
      );


}
