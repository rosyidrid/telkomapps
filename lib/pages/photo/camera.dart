import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';
import 'package:telkom_apps/pages/task/checkin_task.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;

  Future<void> initializeCamera() async {
    var camera = await availableCameras();
    _controller = CameraController(camera[1], ResolutionPreset.max);
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF4949),
        title: Text('Ambil Foto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
          future: initializeCamera(),
          builder: (context, snapshot) => (snapshot.connectionState ==
                  ConnectionState.done)
              ? Stack(children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: CameraPreview(_controller),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: FloatingActionButton(
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
                          backgroundColor: Color(0xFFFF4949),
                          child: const Icon(Icons.camera_alt),
                        ),
                      )
                    ],
                  )
                ])
              : Center(
                  child: CircularProgressIndicator(),
                )),
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
              Image.file(File(imagePath), height: size.height * .6),
              ElevatedButton(
                onPressed: () {
                  _upload(context);
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

  Future _upload(context) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    var id = prefs.get('checkin_id');
    var data = {'checkin_id': id, 'photo_selfie': imagePath};
    var upload = await CallAPI().upload(token, 'checkin/photo/selfie', data);
    var body = json.decode(upload.body);
    if (upload.statusCode == 200) {
      var message = body['message'];
      Widget okButton = TextButton(
        child: Text("Back to Task"),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TaskPage(),
            ),
          );
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Success"),
        content: Text("$message"),
        actions: [
          okButton,
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    } else {
      var message = body['message'];
      Widget okButton = TextButton(
        child: Text("Back to Task"),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TaskPage(),
            ),
          );
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Failed"),
        content: Text("$message"),
        actions: [
          okButton,
        ],
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          });
    }
  }
}
