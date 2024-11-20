// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';

// Future<void> loadModel() async {
//   String? res = await Tflite.loadModel(
//     model: "assets/best_saved_model/best_float32.tflite", // Caminho do arquivo .tflite
//     labels: "assets/models/labelmap.txt", // Arquivo de rótulos, se necessário
//   );
//   log(res ?? 'Modelo carregado com sucesso');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await loadModel();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Teste TFLite')),
//         body: Center(child: Text('Modelo carregado')),
//       ),
//     );
//   }
// }
