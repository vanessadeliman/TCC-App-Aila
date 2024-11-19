/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ObjectDetection {
  static const String _modelPath =
      'assets/best_saved_model/best_float32.tflite';
  static const String _labelPath = 'assets/models/labelmap.txt';

  Interpreter? _interpreter;
  List<String>? _labels;

  ObjectDetection() {
    _loadModel();
    _loadLabels();
    log('Done.');
  }

  Future<void> _loadModel() async {
    log('Loading interpreter options...');
    final interpreterOptions = InterpreterOptions();

    // Use XNNPACK Delegate
    if (Platform.isAndroid) {
      interpreterOptions.addDelegate(XNNPackDelegate());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      interpreterOptions.addDelegate(GpuDelegate());
    }

    log('Loading interpreter...');
    _interpreter =
        await Interpreter.fromAsset(_modelPath, options: interpreterOptions);
  }

  Future<void> _loadLabels() async {
    log('Loading labels...');
    final labelsRaw = await rootBundle.loadString(_labelPath);
    _labels = labelsRaw.split('\n');
  }

List<List<Object>> _runInference(List<List<List<num>>> imageMatrix) {
  log('Running inference...');
  final input = [imageMatrix];
  final output = {
    0: [List<List<num>>.filled(6, List<num>.filled(8400, 0))], // Ajuste para 6 valores por caixa e 8400 caixas
    1: [List<num>.filled(8400, 0)], // Ajuste para 8400 scores
    2: [List<num>.filled(8400, 0)], // Ajuste para 8400 classes
    3: [0.0], // Número de detecções
  };
  _interpreter!.runForMultipleInputs([input], output);
  return output.values.toList();
}

Uint8List analyseImage(String imagePath) {
  log('Analysing image...');
  
  // Ler bytes da imagem do arquivo
  final imageData = File(imagePath).readAsBytesSync();

  // Decodificar a imagem
  final image = img.decodeImage(imageData);

  // Redimensionar a imagem para o modelo (640x640)
  final imageInput = img.copyResize(
    image!,
    width: 640,
    height: 640,
  );

  // Criar matriz de representação da imagem (640x640x3)
  final imageMatrix = List.generate(
    imageInput.height,
    (y) => List.generate(
      imageInput.width,
      (x) {
        final pixel = imageInput.getPixel(x, y);
        return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0]; // Normalizado para [0, 1]
      },
    ),
  );

  // Executar inferência
  final output = _runInference(imageMatrix);

  log('Processing outputs...');
  // Extrair as coordenadas, classes e scores
  final List<List<num>> locations = output[0][0] as List<List<num>>;
  final List<num> scores = output[1][0] as List<num>;
  final List<num> classes = output[2][0] as List<num>;

  // Determinar a quantidade de deteções (ajustado para 8400)
  final detections = scores.where((score) => score > 0.6).toList();
  final numberOfDetections = detections.length;

  log('Detected $numberOfDetections objects.');

  log('Classifying detected objects...');
  final List<String> classifications = [];
  final List<List<int>> boxes = [];

  for (var i = 0; i < numberOfDetections; i++) {
    final idx = scores.indexOf(detections[i]);
    classifications.add(_labels![classes[idx].toInt()]);
    boxes.add([
      (locations[0][idx] * 640).toInt(), // y_min
      (locations[1][idx] * 640).toInt(), // x_min
      (locations[2][idx] * 640).toInt(), // y_max
      (locations[3][idx] * 640).toInt(), // x_max
    ]);
  }

  log('Outlining objects...');
  for (var i = 0; i < boxes.length; i++) {
    // Desenhar retângulos
    img.drawRect(
      imageInput,
      x1: boxes[i][1], // x_min
      y1: boxes[i][0], // y_min
      x2: boxes[i][3], // x_max
      y2: boxes[i][2], // y_max
      color: img.ColorRgb8(255, 0, 0),
      thickness: 3,
    );

    // Adicionar rótulos
    img.drawString(
      imageInput,
      '${classifications[i]} ${scores[i].toStringAsFixed(2)}',
      font: img.arial14,
      x: boxes[i][1] + 1,
      y: boxes[i][0] + 1,
      color: img.ColorRgb8(255, 0, 0),
    );
  }

  log('Done.');
  return img.encodeJpg(imageInput);
}

}
