import 'package:aila/db/modelos/analise.dart';
import 'package:aila/utils/ext_widget.dart';
import 'package:flutter/material.dart';

class BotaoCompartilhar extends StatelessWidget {
  final Analise analise;
  const BotaoCompartilhar(this.analise, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          gerarCSV(analise.nome, analise.coletas);
        },
        icon: const Icon(Icons.share));
  }
}
