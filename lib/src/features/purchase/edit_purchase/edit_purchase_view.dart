import 'package:flutter/material.dart';
import 'package:flutter_sqfl_windows/src/share/dao/payment_method_dao.dart';
import '../../../share/dao/product_dao.dart';
import '../../../share/dao/provider_dao.dart';
import '../../../share/dao/purchases_dao.dart';
import '../../../share/models/buy_model.dart';
import '../../../share/models/payment_method_model.dart';
import '../../../share/models/product_model.dart';
import '../../../share/models/provider_model.dart';
import '../../../share/models/purchase_product_model.dart';

class EditPurchaseView extends StatefulWidget {
  const EditPurchaseView({super.key, this.purchaseParameter});

  final PurchaseModel? purchaseParameter;

  @override
  State<EditPurchaseView> createState() => _EditPurchaseViewState();
}

class _EditPurchaseViewState extends State<EditPurchaseView> {
  final PaymentMethodDao _paymentMethodDao = PaymentMethodDao();
  final ProductDao _productDao = ProductDao();
  final ProviderDao _providerDao = ProviderDao();
  final PurchaseDao _purchaseDao = PurchaseDao();

  PaymentMethodModel? paymentMethod;
  ProductModel? product;
  ProviderModel? provider;
  PurchaseModel purchase = PurchaseModel.empty();

  List<PaymentMethodModel> paymentMethods = [];
  List<ProductModel> products = [];
  List<ProviderModel> providers = [];

  double total = 0;

  void selectAllClients() async {
    try {
      providers = await _providerDao.selectAll();
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
    purchase.idProvider = provider!.id!;
    purchase.idPaymentMethod = paymentMethod!.id!;
    purchase.price = product!.price.toDouble();
    purchase.date = DateTime.now();

    if (purchase.id == null) {
      insertPurchase();
      return;
    }

    updatePurchase();
  }

  void insertPurchase() async {
    try {
      PurchaseModel insertedSale = await _purchaseDao.insert(purchase);
      purchase.id = insertedSale.id;
      await _purchaseDao.insertPurchaseProduct(PurchaseProductModel(id_purchase: purchase.id!, id_product: product!.id!, price: product!.price.toDouble(), quantity: 1));
      mostrarMensagem('Venda inserido com sucesso');
      setState(() {});
    } catch (error) {
      mostrarMensagem('Erro ao inserir venda');
    }
  }

  void updatePurchase() async {
    try {
      if (await _purchaseDao.update(purchase)) {
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
      if (purchase.id == null) {
        mostrarMensagem('Impossivel deletar venda não cadastrado');
        return;
      }
      if (await _purchaseDao.delete(purchase)) {
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
    PurchaseModel? purchaseParameter = widget.purchaseParameter;

    if (purchaseParameter != null) {
      purchase = purchaseParameter;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.purchaseParameter != null ? "Editar" : "Criar"} Compra'),
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
              width: size.width*0.7,
              height: 50,
              child: FutureBuilder(
                future: providers.isEmpty ? _providerDao.selectAll() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    providers = snapshot.data as List<ProviderModel>;
                    if (widget.purchaseParameter != null) {
                      provider = providers.firstWhere((element) => element.id == purchase.idProvider);
                    }
                    return DropdownButton<ProviderModel>(
                      underline: Container(),
                      value: provider,
                      items: providers.map((ProviderModel client) {
                        return DropdownMenuItem<ProviderModel>(
                          value: client,
                          alignment: Alignment.center,
                          child: Text(client.name),
                        );
                      }).toList(),
                      onChanged: (ProviderModel? client) {
                        setState(() {
                          provider = client!;
                        });
                      },
                      isExpanded: true,
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
              width: size.width*0.7,
              height: 50,
              child: FutureBuilder(
                future: products.isEmpty ? _productDao.selectAll() : null,
                builder: (context, snapshot) {
                  if (!snapshot.hasData && widget.purchaseParameter != null) {
                    return const CircularProgressIndicator();
                  }

                  products = snapshot.data as List<ProductModel>;
                  return FutureBuilder(
                    future: widget.purchaseParameter != null ? _productDao.getProductFromPurchase(products, widget.purchaseParameter!.id!) : null,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        ProductModel receivedProduct = (snapshot.data as List<ProductModel>).first;
                        product = products.firstWhere((element) => element.id == receivedProduct.id);
                      }
                      return DropdownButton<ProductModel>(
                        value: product,
                        underline: Container(),
                        items: products.map((ProductModel productDropItem) {
                          return DropdownMenuItem<ProductModel>(
                            value: productDropItem,
                            alignment: Alignment.center,
                            child: Text(productDropItem.name),
                          );
                        }).toList(),
                        onChanged: (ProductModel? productChanged) {
                          total = productChanged!.price;
                          setState(() => product = productChanged);
                        },
                        isExpanded: true,
                      );
                    },
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
              width: size.width*0.7,
              height: 50,
              child: FutureBuilder(
                future: paymentMethods.isEmpty ? _paymentMethodDao.selectAll() : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    paymentMethods = snapshot.data as List<PaymentMethodModel>;
                    if (widget.purchaseParameter != null) {
                      paymentMethod = paymentMethods.firstWhere((element) => element.id == purchase.idPaymentMethod);
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
            const SizedBox(
              height: 10,
            ),
            const SizedBox(height: 25),
            Visibility(
              visible: widget.purchaseParameter == null,
              child: Container(
                alignment: Alignment.center,
                width: size.width*0.7,
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
                  style: ElevatedButton.styleFrom(backgroundColor: purchase.id != null ? Colors.red : Colors.grey),
                  onPressed: purchase.id != null ? () => deleteProvider() : null,
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
