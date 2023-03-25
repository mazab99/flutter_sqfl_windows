import 'package:flutter/material.dart';
import 'package:flutter_sqfl_windows/src/share/dao/payment_method_dao.dart';
import 'package:flutter_sqfl_windows/src/share/models/sale_product_model.dart';
import '../../../share/dao/client_dao.dart';
import '../../../share/dao/product_dao.dart';
import '../../../share/dao/sale_dao.dart';
import '../../../share/models/client_model.dart';
import '../../../share/models/payment_method_model.dart';
import '../../../share/models/product_model.dart';
import '../../../share/models/sale_model.dart';

class EditSaleView extends StatefulWidget {
  const EditSaleView({super.key, this.saleParameter});

  final SaleModel? saleParameter;

  @override
  State<EditSaleView> createState() => _EditSaleViewState();
}

class _EditSaleViewState extends State<EditSaleView> {
  final PaymentMethodDao _paymentMethodDao = PaymentMethodDao();
  final ProductDao _productDao = ProductDao();
  final ClientDao _clientDao = ClientDao();
  final SaleDao _saleDao = SaleDao();

  PaymentMethodModel? paymentMethod;
  ProductModel? product;
  ClientModel? client;
  SaleModel sale = SaleModel.empty();

  List<PaymentMethodModel> paymentMethods = [];
  List<ProductModel> products = [];
  List<ClientModel> clients = [];

  double total = 0;

  void selectAllClients() async {
    try {
      clients = await _clientDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar clientes")));
    }
  }

  void selectAllProducts() async {
    try {
      products = await _productDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar produtos")));
    }
  }

  void save() {
    sale.clientId = client!.id!;
    sale.paymentMethod = paymentMethod!.id!;
    sale.total = product!.price.toDouble();
    sale.date = DateTime.now();

    if (sale.id == null) {
      insertSale();
      return;
    }

    updateSale();
  }

  void insertSale() async {
    try {
      SaleModel insertedSale = await _saleDao.insert(sale);
      sale.id = insertedSale.id;
      mostrarMensagem('Venda inserido com sucesso');
      setState(() {});
    } catch (error) {
      mostrarMensagem('Erro ao inserir venda');
    }
  }

  void updateSale() async {
    try {
      if (await _saleDao.update(sale)) {
        mostrarMensagem("Venda atualizado com sucesso");
        return;
      }
      mostrarMensagem('Nenhum dado foi alterado');
    } catch (error) {
      mostrarMensagem('Erro ao atualizar venda');
    }
  }

  void deleteProvider() async {
    try {
      if (sale.id == null) {
        mostrarMensagem('Impossivel deletar venda não cadastrado');
        return;
      }
      if (await _saleDao.delete(sale)) {
        mostrarMensagem("Venda excluído com sucesso");
        Navigator.pop(context);
        return;
      }
      mostrarMensagem('Nenhum venda foi deletado');
    } catch (error) {
      mostrarMensagem('Erro ao excluir venda');
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Future<void> didChangeDependencies() async {
    SaleModel? saleParameter = widget.saleParameter;

    if (saleParameter != null) {
      sale = saleParameter;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.saleParameter != null ? "Editar" : "Criar"} Venda'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width * 0.7,
              height: 50,
              child: FutureBuilder(
                future: clients.isEmpty ? _clientDao.selectAll() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    clients = snapshot.data as List<ClientModel>;
                    if (widget.saleParameter != null) {
                      client = clients.firstWhere((element) => element.id == sale.clientId);
                    }
                  }
                  return DropdownButton<ClientModel>(
                    value: client,
                    underline: Container(),
                    items: clients.map((ClientModel client) {
                      return DropdownMenuItem<ClientModel>(
                        value: client,
                        alignment: Alignment.center,
                        child: Text(client.name),
                      );
                    }).toList(),
                    onChanged: (ClientModel? client) {
                      setState(() {
                        this.client = client!;
                      });
                    },
                    isExpanded: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width * 0.7,
              height: 50,
              child: FutureBuilder(
                future: products.isEmpty ? _productDao.selectAll() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    products = snapshot.data as List<ProductModel>;
                    return FutureBuilder(
                      future: widget.saleParameter != null ? _productDao.getProductFromSale(products, widget.saleParameter!.id!) : null,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<SaleProductModel> saleProduct = snapshot.data as List<SaleProductModel>;
                          if (widget.saleParameter != null) {
                            product = products.firstWhere((element) => element.id == saleProduct.first.id_produto);
                            total = product!.price;
                          }
                        }
                        return DropdownButton<ProductModel>(
                          value: product,
                          underline: Container(),
                          items: products.map((ProductModel product) {
                            return DropdownMenuItem<ProductModel>(
                              value: product,
                              alignment: Alignment.center,
                              child: Text(product.name),
                            );
                          }).toList(),
                          onChanged: (ProductModel? product) {
                            total = product!.price;
                            setState(() => this.product = product);
                          },
                          isExpanded: true,
                        );
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              width: size.width * 0.7,
              height: 50,
              child: FutureBuilder(
                future: paymentMethods.isEmpty ? _paymentMethodDao.selectAll() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    paymentMethods = snapshot.data as List<PaymentMethodModel>;
                    if (widget.saleParameter != null) {
                      paymentMethod = paymentMethods.firstWhere((element) => element.id == sale.paymentMethod);
                    }
                  }

                  return DropdownButton<PaymentMethodModel>(
                    underline: Container(),
                    value: paymentMethod,
                    items: paymentMethods.map((PaymentMethodModel paymentMethod) {
                      return DropdownMenuItem<PaymentMethodModel>(
                        value: paymentMethod,
                        alignment: Alignment.center,
                        child: Text(paymentMethod.name),
                      );
                    }).toList(),
                    onChanged: (PaymentMethodModel? paymentMethod) {
                      setState(() {
                        this.paymentMethod = paymentMethod!;
                      });
                    },
                    isExpanded: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Visibility(
              visible: widget.saleParameter == null,
              child: Container(
                alignment: Alignment.center,
                width: size.width * 0.7,
                height: 50,
                child: Text("Valor final: $total"),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => save(),
                  child: const Text('Enviar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: sale.id != null ? Colors.red : Colors.grey),
                  onPressed: sale.id != null ? () => deleteProvider() : null,
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
