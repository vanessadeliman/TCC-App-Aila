import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:flutter/material.dart';

class DialogExcluirAnalise extends StatelessWidget {
  final Analise analise;
  const DialogExcluirAnalise(this.analise, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Atenção"),
      content: Text(
          "Tem certeza que deseja excluir a análise ${analise.nome}? Essa ação não pode ser desfeita."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Voltar')),
        FilledButton(
            onPressed: () {
              DatabaseConexao().deleteAnalise(analise).whenComplete(() {
                Navigator.pop(context);
              });
            },
            child: const Text('Confirmar'))
      ],
    );
  }
}
