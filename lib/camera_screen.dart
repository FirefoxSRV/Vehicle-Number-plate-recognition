import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show basename, join;
import 'form_page.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'constants.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? _image;
  bool _isImageCaptured = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> extractTextFromImage(String imagePath, BuildContext context) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final TextRecognizer textRecognizer = GoogleMlKit.vision.textRecognizer();

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String detectedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        detectedText += line.text + '\n';  // Combine recognized lines
      }
    }

    textRecognizer.close();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(recognizedText: detectedText,imagePath: imagePath,),
      ),
    );
  }


  Future<void> capturePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _image = image;
        _isImageCaptured = true;
      });
      print("Picture taken: ${image.path}");

    } catch (e) {
      print(e);
    }
  }

  void goToNextScreen(BuildContext context) async {
    if (_image != null) {
      await extractTextFromImage(_image!.path, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: _image == null ? CameraPreview(_controller) : Image.file(File(_image!.path)),
                ),
                MaterialButton(
                  color: buttonBackground,
                  onPressed: _isImageCaptured ? () => goToNextScreen(context) : capturePicture,
                  child: Text(_isImageCaptured ? 'NEXT' : 'Capture Picture',style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}










