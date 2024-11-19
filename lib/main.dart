import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<Map<String, dynamic>> resultados =
      await DatabaseConexao().getAnalises();

  final List<Analise> analises =
      List.from(resultados.map((element) => Analise.fromMap(element)));

  runApp(MyApp(analises));
}

class MyApp extends StatelessWidget {
  final List<Analise> analises;
  const MyApp(this.analises, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(analises),
    );
  }
}
