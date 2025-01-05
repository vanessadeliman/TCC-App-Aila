import 'dart:io';

import 'package:aila/telas/telas_internas/analise/camera.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BotaoCameraGaleria extends StatelessWidget {
  final bool camera;
  final Function(void Function()) atualiza;
  final List<String> imagens;
  const BotaoCameraGaleria(this.atualiza, this.imagens,
      {this.camera = true, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: camera
          ? () async {
              late List<CameraDescription> cameras;
              cameras = await availableCameras();
              String? imagem = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return Camera(cameras[0]);
              }));
              if (imagem != null) {
                imagens.add(imagem);
              }
              atualiza.call(() {});
            }
          : () async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);

              if (result != null) {
                List<File> files =
                    result.paths.map((path) => File(path!)).toList();
                for (File index in files) {
                  imagens.add(index.path);
                }
                atualiza.call(() {});
              } else {
                // User canceled the picker
              }
            },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(camera ? Icons.camera : Icons.upload),
            Text(
              camera ? 'Abrir Camera' : 'Imagens da Galeria',
              style: Theme.of(context).textTheme.labelSmall,
            )
          ],
        ),
      ),
    );
  }
}
