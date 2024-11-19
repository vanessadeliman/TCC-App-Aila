import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera(this.camera, {super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    controller = CameraController(widget.camera, ResolutionPreset.high);

    try {
      // Inicialize a câmera
      await controller.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Acesso à câmera negado")),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erro na câmera: $e")),
            );
            break;
        }
      }
    }
  }

  Future<void> _takePicture() async {
    try {
      _initializeControllerFuture = controller.initialize(); 
      await _initializeControllerFuture;

      // Tira a foto
      await controller.takePicture().then((foto) {
        log('Foto tirada: ${foto.path}');
        Navigator.pop(context, foto.path);
      });
    } catch (e) {
      log('Erro ao tirar foto: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CameraPreview(controller),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: _takePicture,
              child: const Icon(
                Icons.camera,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
