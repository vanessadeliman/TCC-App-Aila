import 'package:flutter/material.dart';

class InformacoesDaAnalise extends StatelessWidget {
  const InformacoesDaAnalise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 200.0,
          floating: true,
          snap: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Image.asset(
              width: MediaQuery.of(context).size.width,
              'assets/0.jpg',
              fit: BoxFit.cover,
            ),
          ),
          title: const Text('Imagem-5.png'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share))
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    Text(
                      'Mon, Apr 18 - 21:00 Pm',
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  ],
                ),
                const Text('21:00Pm - 23:30Pm'),
                const SizedBox(height: 10),
                Text(
                  'Informações da amostra',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Text('Foram identificadas 5 células:'),
                const SizedBox(height: 10),
                const Text('5 Corados'),
                const Text('0 Não corados'),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Atenção"),
                                content: const Text(
                                    "Tem certeza que deseja excluir a análise \$? Essa ação não pode ser desfeita."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Voltar')),
                                  FilledButton(
                                      onPressed: () {},
                                      child: const Text('Confirmar'))
                                ],
                              );
                            });
                      },
                      child: const Text(
                        'Excluir',
                        style: TextStyle(color: Colors.red),
                      )),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
