import 'dart:io';

import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/camera.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NovaAnalise extends StatefulWidget {
  const NovaAnalise({super.key});

  @override
  State<NovaAnalise> createState() => _NovaAnaliseState();
}

class _NovaAnaliseState extends State<NovaAnalise> {
  final TextEditingController nome = TextEditingController();

  final TextEditingController observacao = TextEditingController();

  List<String> imagens = [];

  GlobalKey<FormState> chave = GlobalKey<FormState>();

  String? validator(String? text) {
    if (nome.text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: chave,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Nova análise',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Informações da análise',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nome,
              validator: validator,
              decoration: const InputDecoration(
                  hintText: 'Digite o nome da análise', labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: observacao,
              decoration: const InputDecoration(
                  hintText: 'Digite uma observação', labelText: 'Observações'),
            ),
            const SizedBox(height: 20),
            Text(
              'Imagem',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);

                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      for (File index in files) {
                        imagens.add(index.path);
                      }
                      setState(() {});
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[300]),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.upload),
                        Text(
                          'Imagem da galeria',
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    late List<CameraDescription> cameras;
                    cameras = await availableCameras();
                    String? imagem = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Camera(cameras[0]);
                    }));
                    if (imagem != null) {
                      setState(() {
                        imagens.add(imagem);
                      });
                    }
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[300]),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.camera),
                        Text(
                          'Abrir camera',
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imagens.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Image.file(File(imagens[index]));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (chave.currentState!.validate() && imagens.isNotEmpty) {
            Analise analise = Analise(
                nome: nome.text,
                data: DateTime.now(),
                observasoes: observacao.text,
                imagem: imagens);
            //TODO incluir a chamada da IA
            await DatabaseConexao().insertAnalise(analise);
          } else {
            if (imagens.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('É necessário selecionar pelo menos 1 imagem.')));
            }
          }
        },
        label: const Text('Salvar'),
      ),
    );
  }
}
