class GoogleScriptPurchaseEntity{
  int? id;
  String? nome_fornecedor;
  String? forma_pagamento;
  double? valor_total;
  DateTime? data;

  GoogleScriptPurchaseEntity({this.id, this.nome_fornecedor, this.forma_pagamento, this.valor_total, this.data});

  factory GoogleScriptPurchaseEntity.fromJson(Map map) => GoogleScriptPurchaseEntity(
    id: map['id'] ?? 1,
    nome_fornecedor: map['nome_fornecedor'] ?? "Sem nome",
    forma_pagamento: map['forma_pagamento'] ?? "Sem forma de pagamento",
    valor_total: map['valor_total'].toDouble() ?? 0.0,
    data: DateTime.tryParse(map['data']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome_fornecedor': nome_fornecedor,
    'forma_pagamento': forma_pagamento,
    'valor_total': valor_total,
    'data': data,
  };
}