import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/componentes/card_analise.dart';
import 'package:aila/telas/nova_analise.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final List<Analise> analises;
  const Home(this.analises, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Analise> analises;

  @override
  void initState() {
    analises = widget.analises;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de análises'),
        actions: [
          IconButton(
              onPressed: () async {
                DateTime? data = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100));
                if (data != null) {
                  final List<Map<String, dynamic>> resultados =
                      await DatabaseConexao().filtrarAnalises(data);
                  analises = List.from(
                      resultados.map((element) => Analise.fromMap(element)));
                  setState(() {});
                }
              },
              icon: const Icon(Icons.calendar_month))
        ],
      ),
      body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: analises.isEmpty ? 1 : analises.length,
            itemBuilder: (context, index) {
              if (analises.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.90,
                  child: const Center(child: Text('Ainda não há análises.')),
                );
              }
              return CardAnalise(analises[index], refresh);
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => NovaAnalise(refresh),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> refresh() async {
    final List<Map<String, dynamic>> resultados =
        await DatabaseConexao().getAnalises();

    analises = List.from(resultados.map((element) => Analise.fromMap(element)));
    setState(() {});
  }
}
