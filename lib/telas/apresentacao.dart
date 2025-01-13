import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/inicializacao/bloc/login_bloc.dart';
import 'package:aila/telas/inicializacao/cadastro.dart';
import 'package:aila/telas/inicializacao/login.dart';
import 'package:aila/telas/inicializacao/tela_conexao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BemVindoPage extends StatelessWidget {
  final List<Analise> analises;
  const BemVindoPage(this.analises, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return TelaConexao(Login(analises));
                }));
              },
              icon: Column(
                children: [
                  const Icon(
                    Icons.network_check,
                    applyTextScaling: true,
                  ),
                  Text(
                    'Conexão',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ))
        ],
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
                              return context
                                      .read<LoginBloc>()
                                      .sessaoAtiva
                                      .ip
                                      .isEmpty
                                  ? TelaConexao(Login(analises))
                                  : Login(analises);
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
                            return context
                                    .read<LoginBloc>()
                                    .sessaoAtiva
                                    .ip
                                    .isEmpty
                                ? TelaConexao(CadastroPage(analises))
                                : CadastroPage(analises);
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
