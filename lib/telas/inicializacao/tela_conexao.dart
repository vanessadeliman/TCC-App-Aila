import 'package:aila/telas/inicializacao/bloc/login_bloc.dart';
import 'package:aila/telas/inicializacao/bloc/state_events_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TelaConexao extends StatelessWidget {
  final TextEditingController ip = TextEditingController();
  final TextEditingController porta = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final Widget proximaTela;
  TelaConexao(this.proximaTela, {super.key});
  String? validacao(String? valor) {
    if (valor != null && valor.isEmpty) {
      return 'Dado obrigatório!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexão'),
      ),
      body: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(),
              controller: ip,
              maxLength: 15,
              validator: validacao,
              decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'IP',
                  hintText: 'Ex.: 192.0.0.1'),
            ),
            TextFormField(
              maxLength: 6,
              keyboardType: const TextInputType.numberWithOptions(),
              controller: porta,
              validator: validacao,
              decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Porta',
                  hintText: 'Ex.: 0000'),
            ),
            Row(
              children: [
                Expanded(
                    child: FilledButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            context.read<LoginBloc>().add(AtualizaConexao(
                                    context, ip.text, porta.text, () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => proximaTela));
                                }));
                          }
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(height: 5),
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
