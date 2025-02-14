import 'dart:io';
import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/componentes/card_analise.dart';
import 'package:aila/telas/inicializacao/bloc/login_bloc.dart';
import 'package:aila/telas/inicializacao/login.dart';
import 'package:aila/telas/inicializacao/tela_conexao.dart';
import 'package:aila/telas/telas_internas/analise/nova_analise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        title: const Text('Histórico'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return TelaConexao(Login(widget.analises));
                }));
              },
              icon: Column(
                children: [
                  const Icon(
                    Icons.network_check,
                    applyTextScaling: true,
                  ),
                  Text(
                    'Conexão',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              )),
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
              icon: Column(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    applyTextScaling: true,
                  ),
                  Text(
                    'Filtrar',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              )),
          IconButton(
              onPressed: () async {
                context.read<LoginBloc>().sessaoAtiva.token = '';
                SharedPreferences cache = await SharedPreferences.getInstance();
                await cache.setString('sessaoAtiva',
                    context.read<LoginBloc>().sessaoAtiva.toJson());
                exit(0);
              },
              icon: Column(
                children: [
                  const Icon(
                    Icons.logout,
                    applyTextScaling: true,
                  ),
                  Text(
                    'Sair',
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ))
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
                    height: MediaQuery.of(context).size.height * .80,
                    child: const Center(child: Text('Ainda não há análises.')));
              }
              return CardAnalise(analises[index], refresh);
            },
          )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Adiciona'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => NovaAnalise(refresh),
            ),
          );
        },
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> refresh() async {
    analises = await DatabaseConexao().getBanco();
    setState(() {});
  }
}
