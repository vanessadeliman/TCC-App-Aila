import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/componentes/botao_camera_galeria.dart';
import 'package:aila/telas/componentes/grid_imagens.dart';
import 'package:aila/telas/informacoes_da_analise.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:image/image.dart' as img;

class NovaAnalise extends StatefulWidget {
  final void Function() atualiza;
  const NovaAnalise(this.atualiza, {super.key});

  @override
  State<NovaAnalise> createState() => _NovaAnaliseState();
}

class _NovaAnaliseState extends State<NovaAnalise> {
  final TextEditingController nome = TextEditingController();
  final TextEditingController observacao = TextEditingController();
  bool _processando = false;
  late Interpreter _interpreter;
  List<String> imagens = [];
  Uint8List? image;

  final newFolderPath = '/storage/emulated/0/Download';
  Analise analise = Analise(data: DateTime.now());

  GlobalKey<FormState> chave = GlobalKey<FormState>();

  @override
  void initState() {
    _loadModel();
    requestStoragePermission();
    super.initState();
  }

  // Carregar o modelo TensorFlow Lite
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
          'assets/best_saved_model/best_float32.tflite');
      log('Modelo carregado com sucesso!');
    } catch (e) {
      log('Erro ao carregar o modelo: $e');
    }
  }

  // Processar a imagem (redimensionar, normalizar e converter para tensor)
  dynamic _processImage(Uint8List imageBytes) {
    var image = img.decodeImage(imageBytes);
    var resizedImage = img.copyResize(image!,
        width: 640, height: 640); // Redimensionar para 640x640
    var convertedImage = resizedImage.getBytes();

    // Converter a imagem para um formato que o modelo espera (normalização dos valores de pixel)
    List<List<List<List<double>>>> inputTensor = List.generate(1, (_) {
      return List.generate(640, (y) {
        return List.generate(640, (x) {
          return [
            (convertedImage[(y * 640 + x) * 3] / 255.0), // R
            (convertedImage[(y * 640 + x) * 3 + 1] / 255.0), // G
            (convertedImage[(y * 640 + x) * 3 + 2] / 255.0) // B
          ];
        });
      });
    });

    return inputTensor;
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  Future<String> _processDetectionResults(
      List output, img.Image originalImage) async {
    // Inicializar contadores para "corado" e "não-corado"
    int coradoCount = 0;
    int naoCoradoCount = 0;

    // Iterar sobre as 8400 caixas de detecção
    for (var i = 0; i < 8400; i++) {
      var x = output[0][0][i]; // x da caixa
      var y = output[0][1][i]; // y da caixa
      var w = output[0][2][i]; // largura da caixa
      var h = output[0][3][i]; // altura da caixa
      var confidence = output[0][4][i]; // confiança da detecção
      var classId = output[0][5][i]; // ID da classe da detecção

      // Verifique a confiança antes de considerar a detecção
      if (confidence > 0.5) {
        // Contabilize as classes "corado" e "não-corado"
        if (classId == 0) {
          // Assumindo que "corado" é a classe 0
          coradoCount++;
        } else if (classId == 1) {
          // Assumindo que "não-corado" é a classe 1
          naoCoradoCount++;
        }

        // Desenhar a caixa de detecção na imagem original
        _drawBoundingBox(originalImage, x, y, w, h);
      }
    }

    // Exibir os resultados de contagem
    log('Labels corado detectados: $coradoCount');
    log('Labels não-corado detectados: $naoCoradoCount');
    analise.corados += coradoCount;
    analise.naoCorados += naoCoradoCount;
    analise.totalCelulas = analise.corados + analise.naoCorados;
    // Atualizar a imagem com as caixas desenhadas
    setState(() {
      image = Uint8List.fromList(img.encodeJpg(
          originalImage)); // Atualize a imagem com as caixas desenhadas
    });
    return await saveImage();
  }

// Função para desenhar a caixa na imagem
  void _drawBoundingBox(
      img.Image image, double x, double y, double width, double height) {
    // Ajustar as coordenadas para que a caixa esteja dentro da imagem
    int x1 = x.toInt();
    int y1 = y.toInt();
    int x2 = (x + width).toInt();
    int y2 = (y + height).toInt();

    // Definir a cor da caixa (vermelho, por exemplo)
    img.Color color = img.ColorRgba8(255, 0, 0, 255);

    // Desenhar a caixa na imagem
    img.drawRect(image, x1: x1, y1: y1, x2: x2, y2: y2, color: color);
  }

// Função de inferência modificada
  Future<String> _runInference(Uint8List imageBytes) async {
    var input = _processImage(imageBytes);

    // Ajustando a forma da saída do modelo para [1, 6, 8400]
    var output = List.generate(
        1, (index) => List.generate(6, (i) => List.filled(8400, 0.0)));

    // Executar a inferência
    _interpreter.run(input, output);
    log('Inferência concluída: $output');

    // Carregar a imagem original
    var originalImage = img.decodeImage(imageBytes)!;

    // Processar os resultados da inferência (Exemplo de detecção de objetos)
    String pathImagem = await _processDetectionResults(output, originalImage);
    return pathImagem;
  }

  Future<void> requestStoragePermission() async {
    // Solicitar permissão para acessar o armazenamento
    PermissionStatus status = await Permission.storage.request();
    if (await Permission.manageExternalStorage.isGranted) {
      log("Permissão concedida.");
      // Chame a função para acessar o armazenamento
    } else if (status.isDenied) {
      log("Permissão negada.");
      // Solicitar a permissão novamente
      requestStoragePermission();
    } else if (status.isPermanentlyDenied) {
      log("Permissão permanentemente negada.");
      // Solicitar para o usuário permitir manualmente nas configurações
      openAppSettings();
    }
  }

  Future<String> saveImage() async {
    final path = '$newFolderPath/${nome.text}.jpg';

    // Criar um arquivo no caminho especificado
    final file = File(path);

    // Salvar o Uint8List no arquivo
    await file.writeAsBytes(image!);

    log("Imagem salva em: $path");
    return path;
  }

  String? validator(String? text) {
    if (nome.text.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
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
                      BotaoCameraGaleria(setState, imagens, camera: false),
                      BotaoCameraGaleria(setState, imagens),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GradeImagens(imagens)
                ],
              ),
            ),
      floatingActionButton: _processando
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                if (chave.currentState!.validate() && imagens.isNotEmpty) {
                  analise.nome = nome.text;
                  analise.observasoes = observacao.text;
                  setState(() {
                    _processando = true;
                  });

                  try {
                    for (var index in imagens) {
                      final imageBytes = File(index).readAsBytesSync();
                      final String pathImagem = await _runInference(imageBytes);
                      analise.imagem.add(pathImagem);
                    }
                    await DatabaseConexao().insertAnalise(analise);
                    setState(() {
                      _processando = false;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InformacoesDaAnalise(analise, widget.atualiza),
                        ));
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
