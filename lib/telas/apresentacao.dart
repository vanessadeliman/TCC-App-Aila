import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/inicializacao/tela_conexao.dart';
import 'package:aila/telas/telas_internas/home.dart';
import 'package:flutter/material.dart';

class BemVindoPage extends StatelessWidget {
  final List<Analise> analises;
  const BemVindoPage(this.analises, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 4,
              ),
              Text(
                'Bem-vindo(a) ao Aila! Estamos felizes em tê-lo(a) conosco.',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
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
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return TelaConexao(Home(analises));
                            }));
                          },
                          child: const Text(
                            'Começar',
                            style: TextStyle(height: 5),
                          ))),
                ],
              ),
              const Spacer(
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
