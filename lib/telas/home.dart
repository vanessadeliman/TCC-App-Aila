import 'package:aila/db/conexao_db.dart';
import 'package:aila/db/modelos/analise.dart';
import 'package:aila/telas/informacoes_da_analise.dart';
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
        title: const Text('Histórico'),
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Última análise',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      width: MediaQuery.of(context).size.width,
                      'assets/0.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 110,
                    color: Colors.grey[300],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mon, Apri 18 - 21:00 Pm'),
                        const Text('imagem.png'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite)),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.share))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
              3,
              (index) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            'assets/${index + 1}.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                    ),
                    title: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mon, Apri 18 - 21:00 Pm'),
                        Text('imagem.png'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.favorite)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.share))
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              InformacoesDaAnalise(Analise()),
                        ),
                      );
                    },
                  ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const NovaAnalise(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
