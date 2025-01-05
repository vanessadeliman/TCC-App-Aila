import 'dart:io';

import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/componentes/botao_compartilhar.dart';
import 'package:aila/telas/componentes/botao_favorito.dart';
import 'package:aila/telas/componentes/dialog_excluir_analise.dart';
import 'package:aila/telas/telas_internas/analise/informacoes_da_analise.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardAnalise extends StatelessWidget {
  final Analise analise;
  final void Function() atualiza;

  const CardAnalise(this.analise, this.atualiza, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);

        showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                offset.dx, offset.dy, renderBox.size.width, 0.0),
            items: [
              PopupMenuItem(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogExcluirAnalise(analise);
                      });
                },
                child: const Text('Excluir'),
              )
            ]);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                InformacoesDaAnalise(analise, atualiza),
          ),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 200,
                    child: analise.coletas.isNotEmpty
                        ? Image.file(
                            File(analise.coletas.first.path),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(child: Icon(Icons.image)),
                          )
                        : Image.asset('asssets/vazio.png'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 110,
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat.yMMMd().format(analise.data)),
                        Text(analise.nome),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BotaoFavorito(analise),
                            BotaoCompartilhar(analise)
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
