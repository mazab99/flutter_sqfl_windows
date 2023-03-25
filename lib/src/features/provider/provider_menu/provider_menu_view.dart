import 'package:flutter/material.dart';
import '../../../share/dao/provider_dao.dart';
import '../../../share/models/provider_model.dart';
import '../edit_provider/edit_provider_page.dart';

class ProviderMenuView extends StatefulWidget {
  const ProviderMenuView({Key? key}) : super(key: key);

  @override
  State<ProviderMenuView> createState() => _ProviderMenuViewState();
}

class _ProviderMenuViewState extends State<ProviderMenuView> {
  List<ProviderModel> clients = [];
  final ProviderDao _providerDao = ProviderDao();

  void selectAllProviders() async {
    try {
      clients = await _providerDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar fornecedores")));
    }
  }

  @override
  void initState() {
    selectAllProviders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GERENCIAR FORNECEDORES'),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProviderPage())).then((value) => selectAllProviders());
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
                  child: Text("Criar fornecedor", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            ProviderModel client = clients[index];
            return ListTile(
              title: Text(client.name),
              subtitle: Text(client.cnpj),

              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProviderPage(providerParameter: clients[index]))).then((value) => selectAllProviders());
                setState(() {});
              },
            );
          },
        ));
  }
}
