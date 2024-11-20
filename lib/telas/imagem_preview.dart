import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final String? imagePath;

  const ImagePreviewPage({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualização'),
      ),
      body: Center(
              child: Image.file(
                File(imagePath ?? ''),
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
