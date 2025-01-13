import 'package:aila/db/modelos/caixa.dart';
import 'package:flutter/material.dart';

class TabelaCelulas extends StatelessWidget {
  final List<Celulas> celulas;
  const TabelaCelulas(this.celulas, {super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        horizontalMargin: 0,
        columnSpacing: 0,
        columns: const [
          DataColumn(label: Text('id')),
          DataColumn(label: Text('Tipo')),
          DataColumn(label: Text('Precisão')),
        ],
        rows: List.generate(celulas.length, (i) {
          final Celulas celula = celulas[i];
          return DataRow(cells: [
            DataCell(Text("${i + 1}")),
            DataCell(Text(celula.nome)),
            DataCell(Text('${(celula.confianca * 100).toStringAsFixed(2)}%'))
          ]);
        }));
  }
}
