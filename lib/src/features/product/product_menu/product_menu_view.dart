import 'package:flutter/material.dart';
import '../../../share/dao/product_dao.dart';
import '../../../share/models/product_model.dart';
import '../edit_product/edit_product_page.dart';

class ProductMenuView extends StatefulWidget {
  const ProductMenuView({Key? key}) : super(key: key);

  @override
  State<ProductMenuView> createState() => _ProductMenuViewState();
}

class _ProductMenuViewState extends State<ProductMenuView> {
  List<ProductModel> products = [];
  final ProductDao _productDao = ProductDao();

  void selectAllProducts() async {
    try {
      products = await _productDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar produtos")));
    }
  }

  @override
  void initState() {
    selectAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GERENCIAR PRODUTOS'),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProductPage())).then((value) => selectAllProducts());
              },
              child: Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: const Center(
                  child: Text("Criar Produto", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            ProductModel client = products[index];
            return ListTile(
              title: Text(client.name),
              subtitle: Text(client.description),

              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProductPage(productParameter: products[index]))).then((value) => selectAllProducts());
                setState(() {});
              },
            );
          },
        ));
  }
}
