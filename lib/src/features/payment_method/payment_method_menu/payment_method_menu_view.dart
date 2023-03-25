import 'package:flutter/material.dart';
import 'package:flutter_sqfl_windows/src/features/payment_method/edit_payment_method/edit_payment_method_view.dart';
import '../../../share/dao/payment_method_dao.dart';
import '../../../share/models/payment_method_model.dart';

class PaymentMethodMenuView extends StatefulWidget {
  const PaymentMethodMenuView({Key? key}) : super(key: key);

  @override
  State<PaymentMethodMenuView> createState() => _PaymentMethodMenuViewState();
}

class _PaymentMethodMenuViewState extends State<PaymentMethodMenuView> {
  List<PaymentMethodModel> paymentMethods = [];
  final PaymentMethodDao _paymentMethodDao = PaymentMethodDao();

  void selectAllPaymentMethod() async {
    try {
      paymentMethods = await _paymentMethodDao.selectAll();
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao buscar metodo de pagamento")));
    }
  }

  @override
  void initState() {
    selectAllPaymentMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('GERENCIAR METODO DE PAGAMENTO'),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditPaymentMethodView())).then((value) => selectAllPaymentMethod());
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
                  child: Text("Criar Metodo de Pagamento", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: paymentMethods.length,
          itemBuilder: (context, index) {
            PaymentMethodModel paymentMethod = paymentMethods[index];
            return ListTile(
              title: Text(paymentMethod.name),
              subtitle: Text(paymentMethod.name),

              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPaymentMethodView(paymentMethodParameter: paymentMethods[index]))).then((value) => selectAllPaymentMethod());
                setState(() {});
              },
            );
          },
        ));
  }
}
