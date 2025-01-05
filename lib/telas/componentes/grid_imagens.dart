import 'dart:io';

import 'package:aila/telas/telas_internas/analise/imagem_preview.dart';
import 'package:flutter/material.dart';

class GradeImagens extends StatefulWidget {
  final List<String> imagens;
  const GradeImagens(this.imagens, {super.key});

  @override
  State<GradeImagens> createState() => _GradeImagensState();
}

class _GradeImagensState extends State<GradeImagens> {
  @override
  Widget build(BuildContext context) {
    return widget.imagens.isEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).highlightColor,
            ),
            height: 200,
            child: const Center(
              child: Text('Nenhuma imagem adicionada'),
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.imagens.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10, crossAxisCount: 2),
            itemBuilder: (context, index) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagePreviewPage(
                                    imagePath: widget.imagens[index],
                                  ),
                                ),
                              );
                            },
                            child: Image.file(
                              File(widget.imagens[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.imagens.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ])));
            },
          );
  }
}
