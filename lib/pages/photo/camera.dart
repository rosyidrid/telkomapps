import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:telkom_apps/pages/photo/photo.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;

  Future<void> initializeCamera() async {
    var camera = await availableCameras();
    _controller = CameraController(camera[1], ResolutionPreset.medium);
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> takePicture() async {
    Directory root = await getTemporaryDirectory();
    String path = '${root.path}/Picture';
    await Directory(path).create(recursive: true);
    String filePath = '$path/${DateTime.now()}.png';
    try {
      await _controller.takePicture();
    } catch (e) {
      print(e);
    }
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
          future: initializeCamera(),
          builder: (context, snapshot) =>
              (snapshot.connectionState == ConnectionState.done)
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: CameraPreview(_controller),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final image = await _controller.takePicture();
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4949),
        title: Text('Hasil Foto'),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.file(File(imagePath)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Upload Foto"),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF4949),
                  minimumSize: Size(size.width * 0.8, 40),
                ),
              )
            ]),
      ),
    );
  }
}
