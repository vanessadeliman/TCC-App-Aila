import 'dart:developer';
import 'dart:io';

import 'package:aila/db/modelos/coleta.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

extension GeraCSV on Widget {
  // Função para converter os dados para CSV
  Future<void> gerarCSV(String nome, List<Coleta> coletas) async {
    String titulo = nome;
    List<List<dynamic>> rows = [
      ['id', 'Tipo', 'Precisão']
    ];

    int contado = 1;
    List<XFile> xfiles = [];
    for (var coleta in coletas) {
      for (int i = 0; i < coleta.celula.length; i++) {
        rows.add([
          i + 1,
          coleta.celula[i].nome,
          '${(coleta.celula[i].confianca * 100).toStringAsFixed(2)}%'
        ]);
      }

      String csvData = const ListToCsvConverter().convert(rows);

      titulo = titulo.replaceAll(' ', '-');

      if (coletas.length > 1) {
        titulo = '$titulo${contado.toString()}';
        contado++;
      }

      String filePath = await _getFilePath(titulo);
      File file = File(filePath);
      await file.writeAsString(csvData);
      log('Arquivo CSV gerado em: $filePath');
      xfiles.add(XFile(filePath));
    }

    _shareFile(xfiles);
  }

  Future<String> _getFilePath(String nome) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$nome.csv';
    return filePath;
  }

  Future<void> _shareFile(List<XFile> files) async {
    try {
      Share.shareXFiles(files, text: 'Compartilhando CSV de Células');
    } catch (e) {
      log('Erro ao compartilhar o arquivo: $e');
    }
  }
}
