import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/camera.dart';
import 'package:aila/telas/ia/objeto_identificador.dart';
import 'package:aila/telas/imagem_preview.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class NovaAnalise extends StatefulWidget {
  const NovaAnalise({super.key});

  @override
  State<NovaAnalise> createState() => _NovaAnaliseState();
}

class _NovaAnaliseState extends State<NovaAnalise> {
  final TextEditingController nome = TextEditingController();
  final TextEditingController observacao = TextEditingController();
  ObjectDetection? objectDetection;

  bool _processando = false;

  List<String> imagens = [];
  Uint8List? image;

  GlobalKey<FormState> chave = GlobalKey<FormState>();

  String? validator(String? text) {
    if (nome.text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    objectDetection = ObjectDetection();
  }

  Future<void> runModel(String path) async {
    image = objectDetection!.analyseImage(path);
    Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImagePreviewPage(
                                                  image: image,
                                                ),
                                              ),
                                            );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova análise'),
      ),
      body: _processando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: chave,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Informações da análise',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nome,
                    validator: validator,
                    decoration: const InputDecoration(
                        hintText: 'Digite o nome da análise',
                        labelText: 'Nome'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: observacao,
                    decoration: const InputDecoration(
                        hintText: 'Digite uma observação',
                        labelText: 'Observações'),
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
                            List<File> files = result.paths
                                .map((path) => File(path!))
                                .toList();
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
                  imagens.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).highlightColor,
                          ),
                          height: 200,
                          child: const Center(
                            child: Text('Nenhuma imagem adicionada'),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: imagens.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10, crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Stack(children: [
                                      Positioned.fill(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImagePreviewPage(
                                                  imagePath: imagens[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.file(
                                            File(imagens[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              imagens.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ])));
                          },
                        )
                ],
              ),
            ),
      floatingActionButton: _processando
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                if (chave.currentState!.validate() && imagens.isNotEmpty) {
                  Analise analise = Analise(
                      nome: nome.text,
                      data: DateTime.now(),
                      observasoes: observacao.text,
                      imagem: imagens);
                  setState(() {
                    _processando = true;
                  });

                  try {
                    for (var index in imagens) {
                      await runModel(index);
                    }
                    await DatabaseConexao().insertAnalise(analise);
                    setState(() {
                      _processando = false;
                    });
                  } catch (e) {
                    log('Ocorreu um erro: $e');
                    setState(() {
                      _processando = false;
                    });
                  }
                } else {
                  if (imagens.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'É necessário selecionar pelo menos 1 imagem.')));
                  }
                }
              },
              label: const Text('Salvar'),
            ),
    );
  }
}
