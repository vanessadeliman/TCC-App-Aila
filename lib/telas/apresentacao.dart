import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/inicializacao/cadastro.dart';
import 'package:aila/telas/inicializacao/login.dart';
import 'package:flutter/material.dart';

class BemVindoPage extends StatelessWidget {
  final List<Analise> analises;
  const BemVindoPage(this.analises, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              const Text(
                'Faça login ou crie uma nova conta',
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
                              return Login(analises);
                            }));
                          },
                          child: const Text(
                            'Entrar',
                            style: TextStyle(height: 5),
                          ))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
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
                            return CadastroPage(analises);
                          }));
                        },
                        child: const Text(
                          'Não tem conta? Cadastre-se',
                          style: TextStyle(height: 5),
                        )),
                  ),
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
