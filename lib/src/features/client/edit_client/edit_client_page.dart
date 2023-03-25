import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqfl_windows/src/share/dao/client_dao.dart';
import 'package:flutter_sqfl_windows/src/share/models/client_model.dart';

class EditClientPage extends StatefulWidget {
  const EditClientPage({super.key, this.clientParameter});

  final ClientModel? clientParameter;

  @override
  State<EditClientPage> createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  ClientModel client = ClientModel.empty();
  final ClientDao _clientDao = ClientDao();

  void save() {
    client.name = _nameController.text;
    client.cpf = _cpfController.text;
    client.phone = _phoneController.text;
    client.address = _addressController.text;
    client.district = _districtController.text;
    client.cep = _cepController.text;

    if (client.id == null) {
      insertClient();
      return;
    }
    updateClient();
  }

  void insertClient() async {
    try {
      ClientModel insertedClient = await _clientDao.insert(client);
      client.id = insertedClient.id;
      mostrarMensagem('Cliente inserido com sucesso');
      setState(() {});
    } catch (error) {
      mostrarMensagem('Erro ao inserir cliente');
    }
  }

  void updateClient() async {
    try {
      if (await _clientDao.update(client)) {
        mostrarMensagem("Cliente atualizado com sucesso");
        return;
      }
      mostrarMensagem('Nenhum dado foi alterado');
    } catch (error) {
      mostrarMensagem('Erro ao atualizar cliente');
    }
  }

  void deleteClient() async {
    try {
      if (client.id == null) {
        mostrarMensagem('Impossivel deletar cliente não cadastrado');
        return;
      }
      if (await _clientDao.delete(client)) {
        mostrarMensagem("Cliente excluído com sucesso");
        Navigator.pop(context);
        return;
      }
      mostrarMensagem('Nenhum cliente foi deletado');
    } catch (error) {
      mostrarMensagem('Erro ao excluir cliente');
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void didChangeDependencies() {
    ClientModel? clientParameter = widget.clientParameter;
    if (clientParameter != null) {
      _nameController.text = clientParameter.name;
      _cpfController.text = clientParameter.cpf;
      _phoneController.text = clientParameter.phone;
      _addressController.text = clientParameter.address;
      _districtController.text = clientParameter.district;
      _cepController.text = clientParameter.cep;
      client = clientParameter;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.clientParameter != null ? "Editar" : "Criar" } Cliente'),
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
                    return 'Por favor, informe o nome do cliente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o CPF do cliente';
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
                    return 'Por favor, informe o telefone do cliente';
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
                    return 'Por favor, informe o endereço do cliente';
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
                    return 'Por favor, informe o bairro do cliente';
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
                    return 'Por favor, informe o CEP do cliente';
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
                    onPressed: client.id != null ? () => deleteClient() : null,
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
