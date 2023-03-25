class ProviderModel {
  int? id;
  String name;
  String cnpj;
  String phone;
  String address;
  String district;
  String cep;

  ProviderModel({
    this.id,
    required this.name,
    required this.cnpj,
    required this.phone,
    required this.address,
    required this.district,
    required this.cep,
  });

  factory ProviderModel.fromSQLite(Map map) => ProviderModel(
        id: map['ID'],
        name: map['NOME'],
        cnpj: map['CNPJ'],
        phone: map['TELEFONE'],
        address: map['ENDERECO'],
        district: map['BAIRRO'],
        cep: map['CEP'],
      );

  static List<ProviderModel> fromSQLiteList(List list) => list.map((e) => ProviderModel.fromSQLite(e)).toList();

  List toSQLiteInsert() => [
        name,
        cnpj,
        phone,
        address,
        district,
        cep,
      ];

  List toSQLiteUpdate() => [
        name,
        cnpj,
        phone,
        address,
        district,
        cep,
        id,
      ];

  factory ProviderModel.empty() => ProviderModel(
        id: null,
        name: '',
        cnpj: '',
        phone: '',
        address: '',
        district: '',
        cep: '',
      );

  List toSQLiteDelete() => [id];
}
