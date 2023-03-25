import 'package:flutter/material.dart';
import '../../../share/dao/product_dao.dart';
import '../../../share/models/product_model.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key, this.productParameter});

  final ProductModel? productParameter;

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  ProductModel product = ProductModel.empty();
  final ProductDao _productDao = ProductDao();

  void save() {
    product.name = _nameController.text;
    product.description = _descriptionController.text;
    product.price = double.tryParse(_priceController.text) ?? 0.0;
    product.stock = double.tryParse(_stockController.text) ?? 0.0;

    if (product.id == null) {
      insertProduct();
      return;
    }
    updateProduct();
  }

  void insertProduct() async {
    try {
      ProductModel insertedProduct = await _productDao.insert(product);
      product.id = insertedProduct.id;
      mostrarMensagem('Produto inserido com sucesso');
      setState(() {});
    } catch (error) {
      mostrarMensagem('Erro ao inserir produto');
    }
  }

  void updateProduct() async {
    try {
      if (await _productDao.update(product)) {
        mostrarMensagem("Produto atualizado com sucesso");
        return;
      }
      mostrarMensagem('Nenhum dado foi alterado');
    } catch (error) {
      mostrarMensagem('Erro ao atualizar produto');
    }
  }

  void deleteProduct() async {
    try {
      if (product.id == null) {
        mostrarMensagem('Impossivel deletar produto não cadastrado');
        return;
      }
      if (await _productDao.delete(product)) {
        mostrarMensagem("Produto excluído com sucesso");
        Navigator.pop(context);
        return;
      }
      mostrarMensagem('Nenhum produto foi deletado');
    } catch (error) {
      mostrarMensagem('Erro ao excluir produto');
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void didChangeDependencies() {
    ProductModel? productParameter = widget.productParameter;
    if (productParameter != null) {
      _nameController.text = productParameter.name;
      _descriptionController.text = productParameter.description;
      _priceController.text = productParameter.price.toString();
      _stockController.text = productParameter.stock.toString();
      product = productParameter;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.productParameter != null ? "Editar" : "Criar"} Produto'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o CNPJ do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o preço do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Estoque',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o estoque do produto';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        save();
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: product.id != null ? Colors.red : Colors.grey,
                    ),
                    onPressed: product.id != null ? () => deleteProduct() : null,
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
