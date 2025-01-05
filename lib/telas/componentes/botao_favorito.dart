import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:flutter/material.dart';

class BotaoFavorito extends StatefulWidget {
  final Analise analise;
  const BotaoFavorito(this.analise, {super.key});

  @override
  State<BotaoFavorito> createState() => _BotaoFavoritoState();
}

class _BotaoFavoritoState extends State<BotaoFavorito> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          widget.analise.favorito = !widget.analise.favorito;
          await DatabaseConexao().updateAnalise(widget.analise);
          setState(() {});
        },
        icon: Icon(
            widget.analise.favorito ? Icons.favorite : Icons.favorite_border));
  }
}
