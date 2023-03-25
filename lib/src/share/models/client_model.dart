class ClientModel {
  int? id;
  String name;
  String cpf;
  String phone;
  String address;
  String district;
  String cep;

  ClientModel({
    this.id,
    required this.name,
    required this.cpf,
    required this.phone,
    required this.address,
    required this.district,
    required this.cep,
  });

  factory ClientModel.fromSQLite(Map map) => ClientModel(
    id: map['ID'],
    name: map['NOME'],
    cpf: map['CPF'],
    phone: map['TELEFONE'],
    address: map['ENDERECO'],
    district: map['BAIRRO'],
    cep: map['CEP'],
  );

  static List<ClientModel> fromSQLiteList(List list) => list.map((e) => ClientModel.fromSQLite(e)).toList();

  List toSQLiteInsert()=> [
    name,
    cpf,
    phone,
    address,
    district,
    cep,
  ];

  List toSQLiteListUpdate()=> [
    name,
    cpf,
    phone,
    address,
    district,
    cep,
    id,
  ];

  factory ClientModel.empty()=> ClientModel(
    id: null,
    name: '',
    cpf: '',
    phone: '',
    address: '',
    district: '',
    cep: '',
  );
}
