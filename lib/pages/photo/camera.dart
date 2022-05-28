import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telkom_apps/API/api.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  var index = 0;
  bool status = false;
  Future<void> initializeCamera() async {
    var camera = await availableCameras();
    _controller = CameraController(camera[index], ResolutionPreset.max,
        enableAudio: false);
    await _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (index == 0) {
                                        index = 1;
                                      } else {
                                        index--;
                                      }
                                    });
                                  },
                                  child: Icon(Icons.flip_camera_ios),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(0, 0, 0, 0),
                                  )),
                              FloatingActionButton(
                                onPressed: () async {
                                  try {
                                    final image =
                                        await _controller.takePicture();
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DisplayPictureScreen(
                                            // Pass the automatically generated path to
                                            // the DisplayPictureScreen widget.
                                            imagePath: image.path,
                                            id: widget.id),
                                      ),
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                backgroundColor: Color(0xFFFF4949),
                                child: const Icon(Icons.camera_alt),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (status == false) {
                                      await _controller
                                          .setFlashMode(FlashMode.always);
                                      status = true;
                                    } else {
                                      await _controller
                                          .setFlashMode(FlashMode.off);
                                      status = false;
                                    }
                                  },
                                  child: status == true
                                      ? Icon(Icons.flash_on_rounded)
                                      : Icon(Icons.flash_off_rounded),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(0, 0, 0, 0),
                                  )),
                            ],
                          )),
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
  final int id;

  const DisplayPictureScreen(
      {Key? key, required this.imagePath, required this.id})
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
    var checkinId = prefs.get('checkin_id');
    var url;
    var photo;
    if (id == 1) {
      url = 'checkin/photo/selfie';
      photo = 'selfie';
    } else if (id == 2) {
      url = 'checkin/photo/stock';
      photo = 'stock';
    } else if (id == 3) {
      url = 'checkin/photo/nota';
      photo = 'nota';
    } else if (id == 4) {
      url = 'checkin/photo/promo';
      photo = 'promo';
    } else {
      url = 'checkin/photo/eup';
      photo = 'harga_eup';
    }
    var data = {'checkin_id': checkinId, 'photo_' + photo: imagePath};
    var upload = await CallAPI().upload(token, url, data, photo);
    var body = json.decode(upload.body);
    var message = body['message'];
    if (upload.statusCode == 200) {
      Widget okButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context, false);
          Navigator.pop(context, false);
          Navigator.pop(context, false);
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Berhasil"),
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
      Widget okButton = TextButton(
        child: Text("Tutup"),
        onPressed: () {
          Navigator.pop(context, false);
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Gagal"),
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
