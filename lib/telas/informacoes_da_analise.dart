import 'dart:io';

import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InformacoesDaAnalise extends StatefulWidget {
  final void Function() atualiza;
  final Analise analise;
  const InformacoesDaAnalise(this.analise, this.atualiza, {super.key});

  @override
  State<InformacoesDaAnalise> createState() => _InformacoesDaAnaliseState();
}

class _InformacoesDaAnaliseState extends State<InformacoesDaAnalise> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => widget.atualiza(),
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
                File(widget.analise.imagem.first),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(widget.analise.nome),
            actions: [
              IconButton(
                  onPressed: () async {
                    widget.analise.favorito = !widget.analise.favorito;
                    await DatabaseConexao().updateAnalise(widget.analise);
                    setState(() {});
                  },
                  icon: Icon(widget.analise.favorito
                      ? Icons.favorite
                      : Icons.favorite_border)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share))
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
                        DateFormat.yMMMd().format(widget.analise.data),
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                  Text(
                    'Informações da amostra',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text('Precisão: ${widget.analise.precisao}'),
                  const SizedBox(height: 10),
                  Text(
                      'Foram identificadas ${widget.analise.totalCelulas} células:'),
                  const SizedBox(height: 10),
                  Text('${widget.analise.corados} Corados'),
                  Text('${widget.analise.naoCorados} Não corados'),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Atenção"),
                                  content: Text(
                                      "Tem certeza que deseja excluir a análise ${widget.analise.nome}? Essa ação não pode ser desfeita."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Voltar')),
                                    FilledButton(
                                        onPressed: () {
                                          DatabaseConexao()
                                              .deleteAnalise(widget.analise)
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Confirmar'))
                                  ],
                                );
                              }).whenComplete(() {
                            widget.atualiza();
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
