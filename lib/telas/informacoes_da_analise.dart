import 'dart:io';

import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/componentes/botao_compartilhar.dart';
import 'package:aila/telas/componentes/botao_favorito.dart';
import 'package:aila/telas/componentes/dialog_excluir_analise.dart';
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
          body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            snap: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.file(
                width: MediaQuery.of(context).size.width,
                File(analise.imagem.first),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(analise.nome),
            actions: [
              BotaoFavorito(analise),
              BotaoCompartilhar(analise)
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      Text(
                        DateFormat.yMMMd().format(analise.data),
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                  Text(
                    'Informações da amostra',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text('Precisão: ${analise.precisao}'),
                  const SizedBox(height: 10),
                  Text('Foram identificadas ${analise.totalCelulas} células:'),
                  const SizedBox(height: 10),
                  Text('${analise.corados} Corados'),
                  Text('${analise.naoCorados} Não corados'),
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
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
