import 'dart:io';

import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _capturedImage;
  bool wajah = false;
  bool kanan = false;
  bool kiri = false;
  String texzt = 'z';
  String keterangan = 'initialize';
  List path = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Builder(builder: (context) {
        if (_capturedImage != null) {
          return SafeArea(
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ElevatedButton(
                      onPressed: () => setState(() => _capturedImage = null),
                      child: const Text(
                        'Capture Again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ))
                ],
              ),
            ),
          );
        }
        return Stack(
          children: [
            SmartFaceCamera(
                autoCapture: false,
                defaultCameraLens: CameraLens.front,
                onCapture: (File? image) {
                  setState(() {
                    if (!wajah) {
                      if (!kanan) {
                        setState(() {
                          kanan = true;
                        });
                      } else {}
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('wajah dicapture!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('terdeteksi kebih dari 1 wajah!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                },
                messageBuilder: (
                  context,
                  face,
                ) {
                  Future.delayed(Duration.zero, () async {});
                  if (face == null) {
                    return _message('posisikan wajah pada tengah ');
                  }
                  if (!face.wellPositioned) {
                    return _message('');
                  }
                  if (face.data.isNotEmpty) {
                    return _message("${face.data} ${face.muka}");
                  }
                  return const SizedBox.shrink();
                }),
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    height: 150,
                    margin: EdgeInsets.only(left: 80, right: 80),
                    padding: EdgeInsets.only(top: 80),
                    child: Container(
                      child: Center(
                        child: Text("$keterangan"),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ))),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.75),
              height: 100,
              child: ListView.builder(
                scrollDirection:
                    Axis.horizontal, // Membuat list menggulir secara horizontal
                itemCount: path.length, // Jumlah item dalam list
                itemBuilder: (BuildContext context, int index) {
                  // Membuat widget Image dengan ukuran 100x100
                  return Container(
                    margin: EdgeInsets.all(8.0), // Spasi antar gambar
                    width: 100.0,
                    height: 100.0,
                    child: Image.file(
                      File(path[
                          index]), // Menggunakan path file gambar dari list
                      fit: BoxFit
                          .cover, // Untuk memastikan gambar terisi dengan baik
                    ),
                  );
                },
              ),
            )
          ],
        );
      })),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
      );
}
