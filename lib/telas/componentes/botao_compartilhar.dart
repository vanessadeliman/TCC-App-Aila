import 'package:aila/db/modelos/analise.dart';
import 'package:flutter/material.dart';

class BotaoCompartilhar extends StatelessWidget {
  final Analise analise;
  const BotaoCompartilhar(this.analise, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: const Icon(Icons.share));
  }
}
