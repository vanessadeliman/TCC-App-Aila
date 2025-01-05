import 'dart:io';

import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/componentes/botao_compartilhar.dart';
import 'package:aila/telas/componentes/botao_favorito.dart';
import 'package:aila/telas/componentes/dialog_excluir_analise.dart';
import 'package:aila/telas/componentes/dialog_detalhes_analise.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InformacoesDaAnalise extends StatelessWidget {
  final void Function() atualiza;
  final Analise analise;
  const InformacoesDaAnalise(this.analise, this.atualiza, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => atualiza(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(analise.nome),
            actions: [BotaoFavorito(analise), BotaoCompartilhar(analise)],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informações da amostra',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                Text(analise.nome),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    Text(
                      DateFormat.yMMMd().format(analise.data),
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text('Observações: ${analise.observasoes}'),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogExcluirAnalise(analise);
                            }).whenComplete(() {
                          atualiza();
                          Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red),
                      )),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: analise.coletas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DialogDetalhesAnalise(
                                              analise.nome,
                                              analise.coletas[index]);
                                        });
                                  },
                                  child: Image.file(
                                    File(analise.coletas[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ])));
                  },
                )
              ],
            ),
          )),
    );
  }
}
