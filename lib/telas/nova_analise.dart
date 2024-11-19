import 'package:flutter/material.dart';

class NovaAnalise extends StatelessWidget {
  const NovaAnalise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Nova análise',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 20),
          Text(
            'Informações da análise',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Digite o nome da análise', labelText: 'Nome'),
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
              Container(
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
              Container(
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
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Salvar'),
      ),
    );
  }
}
