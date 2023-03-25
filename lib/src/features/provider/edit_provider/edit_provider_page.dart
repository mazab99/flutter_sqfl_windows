import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../share/dao/provider_dao.dart';
import '../../../share/models/provider_model.dart';

class EditProviderPage extends StatefulWidget {
  const EditProviderPage({super.key, this.providerParameter});

  final ProviderModel? providerParameter;

  @override
  State<EditProviderPage> createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditProviderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  ProviderModel client = ProviderModel.empty();
  final ProviderDao _providerDao = ProviderDao();

  void save() {
    client.name = _nameController.text;
    client.cnpj = _cnpjController.text;
    client.phone = _phoneController.text;
    client.address = _addressController.text;
    client.district = _districtController.text;
    client.cep = _cepController.text;

    if (client.id == null) {
      insertProvider();
      return;
    }
    updateProvider();
  }

  void insertProvider() async {
    try {
      ProviderModel insertedProvider = await _providerDao.insert(client);
      client.id = insertedProvider.id;
      mostrarMensagem('Fornecedor inserido com sucesso');
      setState(() {});
    } catch (error) {
      mostrarMensagem('Erro ao inserir fornecedor');
    }
  }

  void updateProvider() async {
    try {
      if (await _providerDao.update(client)) {
        mostrarMensagem("Fornecedor atualizado com sucesso");
        return;
      }
      mostrarMensagem('Nenhum dado foi alterado');
    } catch (error) {
      mostrarMensagem('Erro ao atualizar fornecedor');
    }
  }

  void deleteProvider() async {
    try {
      if (client.id == null) {
        mostrarMensagem('Impossivel deletar fornecedor não cadastrado');
        return;
      }
      if (await _providerDao.delete(client)) {
        mostrarMensagem("Fornecedor excluído com sucesso");
        Navigator.pop(context);
        return;
      }
      mostrarMensagem('Nenhum fornecedor foi deletado');
    } catch (error) {
      mostrarMensagem('Erro ao excluir fornecedor');
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void didChangeDependencies() {
    ProviderModel? providerParameter = widget.providerParameter;
    if (providerParameter != null) {
      _nameController.text = providerParameter.name;
      _cnpjController.text = providerParameter.cnpj;
      _phoneController.text = providerParameter.phone;
      _addressController.text = providerParameter.address;
      _districtController.text = providerParameter.district;
      _cepController.text = providerParameter.cep;
      client = providerParameter;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.providerParameter != null ? "Editar" : "Criar" } Fornecedor'),
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
                    return 'Por favor, informe o nome do fornecedor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o CNPJ do fornecedor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o telefone do fornecedor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Endereço, número',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o endereço do fornecedor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o bairro do fornecedor';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o CEP do fornecedor';
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
                      backgroundColor: client.id != null ? Colors.red : Colors.grey,
                    ),
                    onPressed: client.id != null ? () => deleteProvider() : null,
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
