import '../models/product_model.dart';

class ConnectionSQL {
  static const createDatabase = '''
  CREATE TABLE `TB_CLIENTE`(
    `ID` INTEGER PRIMARY KEY AUTOINCREMENT, 
    `NOME` TEXT NOT NULL, 
    `CPF` TEXT NOT NULL, 
    `TELEFONE` TEXT NOT NULL, 
    `ENDERECO` TEXT NOT NULL,
    `BAIRRO` TEXT NOT NULL,
    `CEP` TEXT NOT NULL
  );
  
  CREATE TABLE `TB_PRODUTO`(
    `ID` INTEGER PRIMARY KEY AUTOINCREMENT, 
    `NOME` TEXT NOT NULL, 
    `VALOR` REAL NOT NULL, 
    `ESTOQUE` INTEGER NOT NULL, 
    `DESCRICAO` TEXT NOT NULL
  );
  
 CREATE TABLE `TB_FORNECEDOR`(
    `ID` INTEGER PRIMARY KEY AUTOINCREMENT, 
    `NOME` TEXT NOT NULL, 
    `CNPJ` TEXT NOT NULL, 
    `TELEFONE` TEXT NOT NULL, 
    `ENDERECO` TEXT NOT NULL,
    `BAIRRO` TEXT NOT NULL,
    `CEP` TEXT NOT NULL
  );  
  
  CREATE TABLE `TB_FORMA_PAGAMENTO`(
    `ID` INTEGER PRIMARY KEY AUTOINCREMENT,
    `NOME` TEXT NOT NULL
  );
  
  CREATE TABLE `TB_VENDA`(
    `ID` INTEGER PRIMARY KEY AUTOINCREMENT,
    `ID_CLIENTE` INTEGER NOT NULL,
    `ID_FORMA_PAGAMENTO` INTEGER NOT NULL,
    `VALOR_TOTAL` REAL NOT NULL,
    `DATA` TEXT NOT NULL,
    FOREIGN KEY(`ID_CLIENTE`) REFERENCES TB_CLIENTE(`ID`),
    FOREIGN KEY(`ID_FORMA_PAGAMENTO`) REFERENCES TB_FORMA_PAGAMENTO(`ID`)
  );
  
  CREATE TABLE TB_VENDA_PRODUTO(
    `ID_VENDA` INTEGER NOT NULL,
    `ID_PRODUTO` INTEGER NOT NULL,
    `VALOR` REAL NOT NULL,
    `QUANTIDADE` REAL NOT NULL,
    FOREIGN KEY(`ID_VENDA`) REFERENCES TB_VENDA(`ID`),
    FOREIGN KEY(`ID_PRODUTO`) REFERENCES TB_PRODUTO(`ID`)
  );
  
  CREATE TABLE TB_COMPRA(
    `ID` INTEGER PRIMARY KEY AUTOINCREMENT,
    `ID_FORNECEDOR` INTEGER NOT NULL,
    `ID_FORMA_PAGAMENTO` INTEGER NOT NULL,
    `VALOR_TOTAL` REAL NOT NULL,
    `DATA` TEXT NOT NULL,
    FOREIGN KEY(`ID_FORNECEDOR`) REFERENCES TB_FORNECEDOR(`ID`)
  );
  
  CREATE TABLE TB_COMPRA_PRODUTO(
    `ID_COMPRA` INTEGER NOT NULL,
    `ID_PRODUTO` INTEGER NOT NULL,
    `VALOR` REAL NOT NULL,
    `QUANTIDADE` REAL NOT NULL,
    FOREIGN KEY(`ID_COMPRA`) REFERENCES TB_COMPRA(`ID`),
    FOREIGN KEY(`ID_PRODUTO`) REFERENCES TB_PRODUTO(`ID`)
  );
  ''';

  // ====================== ADD ======================

  static String addClient() => '''
  INSERT INTO TB_CLIENTE (NOME, CPF, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES (?, ?, ?, ?, ?, ?);
  ''';

  static String addProduct() => '''
  INSERT INTO TB_PRODUTO (NOME, VALOR, ESTOQUE, DESCRICAO) VALUES (?, ?, ?, ?);
  ''';

  static String addProvider() => '''
  INSERT INTO TB_FORNECEDOR (NOME, CNPJ, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES (?, ?, ?, ?, ?, ?);
  ''';

  static String addPaymentMethod() => '''
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES (?);
  ''';

  static String addSale() => '''
  INSERT INTO TB_VENDA (ID_CLIENTE, ID_FORMA_PAGAMENTO, VALOR_TOTAL, DATA) VALUES (?, ?, ?, ?);
  ''';

  static String addSaleProduct() => '''
  INSERT INTO TB_VENDA_PRODUTO (ID_PRODUTO, ID_VENDA, QUANTIDADE,  VALOR) VALUES (?, ?, ?, ?);
  ''';

  static String addPurchase() => '''
  INSERT INTO TB_COMPRA (ID_FORNECEDOR, ID_FORMA_PAGAMENTO,VALOR_TOTAL ,DATA) VALUES (?, ?,? , ?);
  ''';

  static String addPurchaseProduct() => '''
  INSERT INTO TB_COMPRA_PRODUTO (ID_COMPRA, ID_PRODUTO, VALOR, QUANTIDADE) VALUES (?, ?, ?, ?);
  ''';

  // ====================== UPDATE ======================

  static String updateClient() => '''
  UPDATE TB_CLIENTE SET NOME = ?, CPF = ?, TELEFONE = ?, ENDERECO = ?, BAIRRO = ?, CEP = ? WHERE ID = ?;
  ''';

  static String updateProduct() => '''
  UPDATE TB_PRODUTO SET NOME = ?, VALOR = ?, ESTOQUE = ?, DESCRICAO = ? WHERE ID = ?;
  ''';

  static String updateProvider() => '''
  UPDATE TB_FORNECEDOR SET NOME = ?, CNPJ = ?, TELEFONE = ?, ENDERECO = ?, BAIRRO = ?, CEP = ? WHERE ID = ?;
  ''';

  static String updatePaymentMethod() => '''
  UPDATE TB_FORMA_PAGAMENTO SET NOME = ? WHERE ID = ?;
  ''';

  static String updateSale() => '''
  UPDATE TB_VENDA SET ID_CLIENTE = ?, ID_FORMA_PAGAMENTO = ?, VALOR_TOTAL = ? , DATA = ? WHERE ID = ?;
  ''';

  static String updateSaleProduct() => '''
  UPDATE TB_VENDA_PRODUTO SET ID_VENDA = ?, ID_PRODUTO = ?, VALOR = ?, QUANTIDADE = ? WHERE ID = ?;
  ''';

  static String updatePurchase() => '''
  UPDATE TB_COMPRA SET ID_FORNECEDOR = ?, ID_FORMA_PAGAMENTO = ?, DATA = ? WHERE ID = ?;
  ''';

  static String updatePurchaseProduct() => '''
  UPDATE TB_COMPRA_PRODUTO SET ID_COMPRA = ?, ID_PRODUTO = ?, VALOR = ?, QUANTIDADE = ? WHERE ID = ?;
  ''';

  // ====================== SELECT ALL ======================

  static String selectAllClient() => '''
  SELECT * FROM TB_CLIENTE;
  ''';

  static String selectAllProduct() => '''
  SELECT * FROM TB_PRODUTO;
  ''';

  static String selectAllProvider() => '''
  SELECT * FROM TB_FORNECEDOR;
  ''';

  static String selectAllPaymentMethod() => '''
  SELECT * FROM TB_FORMA_PAGAMENTO;
  ''';

  static String selectAllSale() => '''
  SELECT * FROM TB_VENDA;
  ''';

  static String selectAllSaleProduct() => '''
  SELECT * FROM TB_VENDA_PRODUTO;
  ''';

  static String selectAllPurchase() => '''
  SELECT * FROM TB_COMPRA;
  ''';

  static String selectAllPurchaseProduct() => '''
  SELECT * FROM TB_COMPRA_PRODUTO;
  ''';

  // ====================== DELETE ======================

  static String deleteClient() => '''
  DELETE FROM TB_CLIENTE WHERE ID = ?;
  ''';

  static String deleteProduct() => '''
  DELETE FROM TB_PRODUTO WHERE ID = ?;
  ''';

  static String deleteProvider() => '''
  DELETE FROM TB_FORNECEDOR WHERE ID = ?;
  ''';

  static String deletePaymentMethod() => '''
  DELETE FROM TB_FORMA_PAGAMENTO WHERE ID = ?;
  ''';

  static String deleteSale() => '''
  DELETE FROM TB_VENDA WHERE ID = ?;
  ''';

  static String deleteSaleProduct() => '''
  DELETE FROM TB_VENDA_PRODUTO WHERE ID = ?;
  ''';

  static String deletePurchase() => '''
  DELETE FROM TB_COMPRA WHERE ID = ?;
  ''';

  static String deletePurchaseProduct() => '''
  DELETE FROM TB_COMPRA_PRODUTO WHERE ID = ?;
  ''';

  // ====================== SELECT BY ======================

  static String selectClientById() => '''
  SELECT * FROM TB_CLIENTE WHERE ID = ?;
  ''';

  static String selectProductById() => '''
  SELECT * FROM TB_PRODUTO WHERE ID = ?;
  ''';

  static String selectProviderById() => '''
  SELECT * FROM TB_FORNECEDOR WHERE ID = ?;
  ''';

  static String selectPaymentMethodById() => '''
  SELECT * FROM TB_FORMA_PAGAMENTO WHERE ID = ?;
  ''';

  static String selectSaleById() => '''
  SELECT * FROM TB_VENDA WHERE ID = ?;
  ''';

  static String selectSaleProductById() => '''
  SELECT * FROM TB_VENDA_PRODUTO WHERE ID_VENDA = ?;
  ''';

  static String selectPurchaseById() => '''
  SELECT * FROM TB_COMPRA WHERE ID = ?;
  ''';

  static String selectPurchaseProductById() => '''
  SELECT * FROM TB_COMPRA_PRODUTO WHERE ID_COMPRA = ?;
  ''';

  static String selectProviderByName() => '''
  SELECT * FROM TB_FORNECEDOR WHERE NOME = ?;
  ''';

  static String selectPaymentMethodByName() => '''
  SELECT * FROM TB_FORMA_PAGAMENTO WHERE NOME = ?;
  ''';

  // ====================== POPULATION TABLES ======================

  static String populatePaymentMethod() => '''
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES ('Dinheiro');
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES ('Cartão de Crédito');
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES ('Cartão de Débito');
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES ('Cheque');
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES ('PIX');
  INSERT INTO TB_FORMA_PAGAMENTO (NOME) VALUES ('Sem nome');
  ''';

  static String populateProduct() => '''
  INSERT INTO TB_PRODUTO (NOME, VALOR, ESTOQUE, DESCRICAO) VALUES ('Coca-Cola', 5.00, 10, 'Refrigerante');
  INSERT INTO TB_PRODUTO (NOME, VALOR, ESTOQUE, DESCRICAO) VALUES ('Pepsi', 5.00, 10, 'Refrigerante');
  INSERT INTO TB_PRODUTO (NOME, VALOR, ESTOQUE, DESCRICAO) VALUES ('Fanta', 5.00, 10, 'Refrigerante');
  INSERT INTO TB_PRODUTO (NOME, VALOR, ESTOQUE, DESCRICAO) VALUES ('Sprite', 5.00, 10, 'Refrigerante');
  ''';

  static String populateProductFromList(List<ProductModel> products) {
    String sql = '';
    for (var product in products) {
      sql += '''
      INSERT INTO TB_PRODUTO (NOME, VALOR, ESTOQUE, DESCRICAO) VALUES ('${product.name}', ${product.price}, ${product.stock}, '${product.description}');
      ''';
    }
    return sql;
  }

  static String populateClient() => '''
  INSERT INTO TB_CLIENTE (NOME, CPF, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('NÃO DEFINIDO', '123.456.789-00', '99999-9999', 'Rua 1', 'Bairro 1', '99999-999');
  INSERT INTO TB_CLIENTE (NOME, CPF, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('João', '123.456.789-00', '99999-9999', 'Rua 1', 'Bairro 1', '99999-999');
  INSERT INTO TB_CLIENTE (NOME, CPF, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('Maria', '123.456.789-00', '99999-9999', 'Rua 2', 'Bairro 2', '99999-999');
  INSERT INTO TB_CLIENTE (NOME, CPF, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('José', '123.456.789-00', '99999-9999', 'Rua 3', 'Bairro 3', '99999-999');
  INSERT INTO TB_CLIENTE (NOME, CPF, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('Pedro', '123.456.789-00', '99999-9999', 'Rua 4', 'Bairro 4', '99999-999');
  ''';

  static String populateProvider() => '''
  INSERT INTO TB_FORNECEDOR (NOME, CNPJ, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('GBarbosa', '123.456.789-00', '99999-9999', 'Rua 1', 'Bairro 1', '99999-999');
  INSERT INTO TB_FORNECEDOR (NOME, CNPJ, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('Americanas', '123.456.789-00', '99999-9999', 'Rua 2', 'Bairro 2', '99999-999');
  INSERT INTO TB_FORNECEDOR (NOME, CNPJ, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('Magalu', '123.456.789-00', '99999-9999', 'Rua 3', 'Bairro 3', '99999-999');
  INSERT INTO TB_FORNECEDOR (NOME, CNPJ, TELEFONE, ENDERECO, BAIRRO, CEP) VALUES ('Casas Bahia', '123.456.789-00', '99999-9999', 'Rua 4', 'Bairro 4', '99999-999');
  ''';

  static String populateSale() => '''
  INSERT INTO TB_VENDA (ID_CLIENTE, ID_FORMA_PAGAMENTO, DATA, VALOR_TOTAL) VALUES (1, 1, '2020-01-01', 20.00);
  INSERT INTO TB_VENDA (ID_CLIENTE, ID_FORMA_PAGAMENTO, DATA, VALOR_TOTAL) VALUES (2, 2, '2020-01-01', 20.00);
  INSERT INTO TB_VENDA (ID_CLIENTE, ID_FORMA_PAGAMENTO, DATA, VALOR_TOTAL) VALUES (3, 3, '2020-01-01', 20.00);
  INSERT INTO TB_VENDA (ID_CLIENTE, ID_FORMA_PAGAMENTO, DATA, VALOR_TOTAL) VALUES (4, 4, '2020-01-01', 20.00);
  ''';

  static String populateSaleProduct() => '''
  INSERT INTO TB_VENDA_PRODUTO (ID_VENDA, ID_PRODUTO, QUANTIDADE,  VALOR) VALUES (1, 1, 2,10.00);
  INSERT INTO TB_VENDA_PRODUTO (ID_VENDA, ID_PRODUTO, QUANTIDADE,  VALOR) VALUES (2, 2, 2,10.00);
  INSERT INTO TB_VENDA_PRODUTO (ID_VENDA, ID_PRODUTO, QUANTIDADE,  VALOR) VALUES (3, 3, 2,10.00);
  INSERT INTO TB_VENDA_PRODUTO (ID_VENDA, ID_PRODUTO, QUANTIDADE,  VALOR) VALUES (4, 4, 2,10.00);
  ''';

  static String populatePurchase() => '''
  INSERT INTO TB_COMPRA (ID_FORNECEDOR, ID_FORMA_PAGAMENTO,DATA, VALOR_TOTAL) VALUES (1, 1,'2020-01-01', 20.00);
  INSERT INTO TB_COMPRA (ID_FORNECEDOR, ID_FORMA_PAGAMENTO,DATA, VALOR_TOTAL) VALUES (2, 2,'2020-01-01', 20.00);
  INSERT INTO TB_COMPRA (ID_FORNECEDOR, ID_FORMA_PAGAMENTO,DATA, VALOR_TOTAL) VALUES (3, 3,'2020-01-01', 20.00);
  INSERT INTO TB_COMPRA (ID_FORNECEDOR, ID_FORMA_PAGAMENTO,DATA, VALOR_TOTAL) VALUES (4, 4,'2020-01-01', 20.00);
  ''';

  static String populatePurchaseProduct() => '''
  INSERT INTO TB_COMPRA_PRODUTO (ID_COMPRA, ID_PRODUTO, QUANTIDADE, VALOR) VALUES (1, 1, 2,10.00);
  INSERT INTO TB_COMPRA_PRODUTO (ID_COMPRA, ID_PRODUTO, QUANTIDADE, VALOR) VALUES (2, 2, 2,10.00);
  INSERT INTO TB_COMPRA_PRODUTO (ID_COMPRA, ID_PRODUTO, QUANTIDADE, VALOR) VALUES (3, 3, 2,10.00);
  INSERT INTO TB_COMPRA_PRODUTO (ID_COMPRA, ID_PRODUTO, QUANTIDADE, VALOR) VALUES (4, 4, 2,10.00);
  ''';


  // ====================== CLEAR ALL TABLES ======================

  static String clearAllTables() => '''
  DELETE FROM TB_CLIENTE;
  DELETE FROM TB_PRODUTO;
  DELETE FROM TB_FORNECEDOR;
  DELETE FROM TB_FORMA_PAGAMENTO;
  DELETE FROM TB_VENDA;
  DELETE FROM TB_VENDA_PRODUTO;
  DELETE FROM TB_COMPRA;
  DELETE FROM TB_COMPRA_PRODUTO;
  ''';
}
