class GoogleScriptStockProductEntity {
  int? codigo_produto;
  DateTime? data_entrada;
  double? quantidade;
  double? valor_unitario;
  String? descricao;

  GoogleScriptStockProductEntity({this.codigo_produto, this.data_entrada, this.quantidade, this.valor_unitario, this.descricao});

  factory GoogleScriptStockProductEntity.fromJson(Map map) =>
      GoogleScriptStockProductEntity(
        codigo_produto: map['codigo_produto'] ?? 1,
        data_entrada: DateTime.parse(map['data_entrada']),
        quantidade: map['quantidade'].toDouble() ?? 0.0,
        valor_unitario: map['valor_unitario'].toDouble() ?? 0.0,
        descricao: map['descricao'] ?? "Sem descrição",
      );

  Map<String, dynamic> toJson() =>
      {
        'codigo_produto': codigo_produto,
        'data_entrada': data_entrada,
        'quantidade': quantidade,
        'valor_unitario': valor_unitario,
        'descricao': descricao,
      };
}