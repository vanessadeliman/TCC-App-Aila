import 'package:aila/db/modelos/coleta.dart';
import 'package:aila/telas/componentes/tabela_celulas.dart';
import 'package:aila/utils/ext_widget.dart';
import 'package:flutter/material.dart';

class DialogDetalhesAnalise extends StatelessWidget {
  final String titulo;
  final Coleta coleta;
  const DialogDetalhesAnalise(this.titulo,this.coleta, {super.key});

  @override
  Widget build(BuildContext context) {
    final int corados = coleta.celula.where((i) => i.nome == "corado").length;
    final int naoCorados =
        coleta.celula.where((i) => i.nome == "nao-corado").length;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
      ),
      backgroundColor: Colors.white,
      title: const Text(
        'Detalhes da Análise',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Na imagem foram identificadas ${corados + naoCorados} células:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  '$corados Corados',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  '$naoCorados Não Corados',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            const SizedBox(height: 12),
            TabelaCelulas(coleta.celula),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              gerarCSV(titulo, [coleta]);
            },
            child: const Text('Download')),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Fechar',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
