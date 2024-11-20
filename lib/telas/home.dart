import 'dart:io';

import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/informacoes_da_analise.dart';
import 'package:aila/telas/nova_analise.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                return const Center(
                  child: Text('Ainda não há análises.'),
                );
              }
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          InformacoesDaAnalise(analises[index], refresh),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 200,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: 200,
                              child: Image.file(
                                File(analises[index].imagem.first),
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(child: Icon(Icons.image)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              height: 110,
                              color: Colors.grey[300],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateFormat.yMMMd()
                                      .format(analises[index].data)),
                                  Text(analises[index].nome),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            analises[index].favorito =
                                                !analises[index].favorito;
                                            await DatabaseConexao()
                                                .updateAnalise(analises[index]);
                                            setState(() {});
                                          },
                                          icon: Icon(analises[index].favorito
                                              ? Icons.favorite
                                              : Icons.favorite_border)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.share))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              );
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
