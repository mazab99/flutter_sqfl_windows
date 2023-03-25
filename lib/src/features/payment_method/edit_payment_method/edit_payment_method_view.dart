import 'package:flutter/material.dart';
import '../../../share/dao/payment_method_dao.dart';
import '../../../share/models/payment_method_model.dart';

class EditPaymentMethodView extends StatefulWidget {
  const EditPaymentMethodView({super.key, this.paymentMethodParameter});

  final PaymentMethodModel? paymentMethodParameter;

  @override
  State<EditPaymentMethodView> createState() => _EditPaymentMethodViewState();
}

class _EditPaymentMethodViewState extends State<EditPaymentMethodView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  PaymentMethodModel paymentMethod = PaymentMethodModel.empty();
  final PaymentMethodDao _paymentMethodDao = PaymentMethodDao();

  void save() {
    paymentMethod.name = _nameController.text;

    if (paymentMethod.id == null) {
      insertPaymentMethod();
      return;
    }
    updatePaymentMethod();
  }

  void insertPaymentMethod() async {
    try {
      PaymentMethodModel insertedPaymentMethod = await _paymentMethodDao.insert(paymentMethod);
      paymentMethod.id = insertedPaymentMethod.id;
      mostrarMensagem('Metodo de pagamento inserido com sucesso');
      setState(() {});
    } catch (error) {
      mostrarMensagem('Erro ao inserir metodo de pagamento');
    }
  }

  void updatePaymentMethod() async {
    try {
      if (await _paymentMethodDao.update(paymentMethod)) {
        mostrarMensagem("Metodo de pagamento atualizado com sucesso");
        return;
      }
      mostrarMensagem('Nenhum dado foi alterado');
    } catch (error) {
      mostrarMensagem('Erro ao atualizar metodo de pagamento');
    }
  }

  void deletePaymentMethod() async {
    try {
      if (paymentMethod.id == null) {
        mostrarMensagem('Impossivel deletar metodo de pagamento não cadastrado');
        return;
      }
      if (await _paymentMethodDao.delete(paymentMethod)) {
        mostrarMensagem("Metodo de pagamento excluído com sucesso");
        Navigator.pop(context);
        return;
      }
      mostrarMensagem('Nenhum metodo de pagamento foi deletado');
    } catch (error) {
      mostrarMensagem('Erro ao excluir metodo de pagamento');
    }
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  void didChangeDependencies() {
    PaymentMethodModel? paymentMethodParameter = widget.paymentMethodParameter;
    if (paymentMethodParameter != null) {
      _nameController.text = paymentMethodParameter.name;
      paymentMethod = paymentMethodParameter;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.paymentMethodParameter != null ? "Editar" : "Criar" } Metodo de Pagamento'),
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
                    return 'Por favor, informe o nome do metodo de pagamento';
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
                      backgroundColor: paymentMethod.id != null ? Colors.red : Colors.grey,
                    ),
                    onPressed: paymentMethod.id != null ? () => deletePaymentMethod() : null,
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
