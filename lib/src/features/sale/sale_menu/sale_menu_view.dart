import 'package:flutter/material.dart';
import 'package:flutter_sqfl_windows/src/share/dao/client_dao.dart';
import 'package:flutter_sqfl_windows/src/share/models/client_model.dart';
import '../../../share/dao/sale_dao.dart';
import '../../../share/models/sale_model.dart';
import '../edit_sale/edit_sale_view.dart';

class SaleMenuView extends StatefulWidget {
  const SaleMenuView({Key? key}) : super(key: key);

  @override
  State<SaleMenuView> createState() => _SaleMenuViewState();
}

class _SaleMenuViewState extends State<SaleMenuView> {
  List<SaleModel> sales = [];

  final SaleDao _saleDao = SaleDao();

  void selectAllSales() async {
    try {
      sales = await _saleDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar Vendas")));
    }
  }

  @override
  void initState() {
    selectAllSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GERENCIAR VENDAS'),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditSaleView())).then((value) => selectAllSales());
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
                  child: Text("Criar Venda", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            SaleModel sale = sales[index];
            return ListTile(
              leading: const Icon(Icons.shopping_basket, color: Colors.green),
              title: FutureBuilder(
                future: ClientDao().selectById(sale.clientId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ClientModel client = snapshot.data as ClientModel;
                    return Text(client.name);
                  } else {
                    return const Text("Carregando...");
                  }
                },
              ),
              trailing: Text("R\$ ${sale.total.toDouble().toStringAsFixed(2)} "),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditSaleView(saleParameter: sales[index]))).then((value) => selectAllSales());
                setState(() {});
              },
            );
          },
        ));
  }
}
