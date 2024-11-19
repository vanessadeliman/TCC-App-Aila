import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final String? imagePath;
  final Uint8List? image;

  const ImagePreviewPage({Key? key, this.imagePath, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualização'),
      ),
      body: image != null
          ? Center(
              child: Image.file(File.fromRawPath(image!)),
            )
          : Center(
              child: Image.file(
                File(imagePath ?? ''),
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
