import 'package:flutter/material.dart';
import 'package:flutter_sqfl_windows/src/features/client/edit_client/edit_client_page.dart';

import '../../../share/dao/client_dao.dart';
import '../../../share/models/client_model.dart';

class ClientMenuView extends StatefulWidget {
  const ClientMenuView({Key? key}) : super(key: key);

  @override
  State<ClientMenuView> createState() => _ClientMenuViewState();
}

class _ClientMenuViewState extends State<ClientMenuView> {
  List<ClientModel> clients = [];
  final ClientDao _clientDao = ClientDao();

  void selectAllClients() async {
    try {
      clients = await _clientDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar clientes")));
    }
  }

  @override
  void initState() {
    selectAllClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GERENCIAR CLIENTES'),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditClientPage())).then((value) => selectAllClients());
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
                  child: Text("Criar Cliente", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            ClientModel client = clients[index];
            return ListTile(
              title: Text(client.name),
              subtitle: Text(client.cpf),

              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditClientPage(clientParameter: clients[index]))).then((value) => selectAllClients());
                setState(() {});
              },
            );
          },
        ));
  }
}
