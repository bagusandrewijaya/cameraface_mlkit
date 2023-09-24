import 'dart:io';

import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'classtakepicture.dart';

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
  bool istwoperson = false;
  String keterangan = 'initialize..';
  String keteranganz = "posisikan wajah ditengah";
  List path = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          if (_capturedImage != null) {
            return SafeArea(
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text(
                        'Capture Again',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
                  if (!istwoperson) {
                    if (keterangan.toLowerCase() ==
                            "tidak menghadap kiri atau kanan" &&
                        !TakeStream.center &&
                        keteranganz.toLowerCase() ==
                            "posisikan wajah ditengah") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('gambar di take'),
                        ),
                      );
                      setState(() {
                        keteranganz = "silahkan menghadap kanan";
                        path.add(image!.path);
                        TakeStream.center = true;
                      });
                    }

                    if (keterangan.toLowerCase() !=
                            "tidak menghadap kiri atau kanan" &&
                        !TakeStream.center &&
                        keteranganz.toLowerCase() ==
                            "posisikan wajah ditengah") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('gambar anda harusnya menghadap tengah'),
                        ),
                      );
                    }

                    if (keterangan.toLowerCase() == "menghadap kanan" &&
                        TakeStream.center &&
                        !TakeStream.right &&
                        !TakeStream.left &&
                        keteranganz.toLowerCase() ==
                            "silahkan menghadap kanan") {
                      setState(() {
                        keteranganz = "silahkan menghadap kiri";
                        TakeStream.right = true;
                        path.add(image!.path);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('gambar anda di ambil'),
                        ),
                      );
                    }

                    if (keterangan.toLowerCase() != "menghadap kanan" &&
                        TakeStream.center &&
                        !TakeStream.right &&
                        !TakeStream.left &&
                        keteranganz.toLowerCase() ==
                            "silahkan menghadap kanan") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('gambar anda harusnya menghadap kanan'),
                        ),
                      );
                    }

                    if (keterangan.toLowerCase() == "menghadap kiri" &&
                        TakeStream.center &&
                        TakeStream.right &&
                        !TakeStream.left &&
                        keteranganz.toLowerCase() ==
                            "silahkan menghadap kiri") {
                      setState(() {
                        path.add(image!.path);
                        TakeStream.left = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('gambar kiri diambil'),
                        ),
                      );
                    }

                    if (keterangan.toLowerCase() != "menghadap kiri" &&
                        TakeStream.center &&
                        TakeStream.right &&
                        !TakeStream.left &&
                        keteranganz.toLowerCase() ==
                            "silahkan menghadap kiri") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('gambar anda harusnya menghadap kiri'),
                        ),
                      );
                    }
                  }
                },
                messageBuilder: (
                  context,
                  face,
                ) {
                  Future.delayed(Duration.zero, () async {
                    setState(() {
                      keterangan = face!.data;
                      istwoperson = face.muka;
                    });
                  });

                  return const SizedBox.shrink();
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 150,
                  margin: EdgeInsets.only(left: 80, right: 80),
                  padding: EdgeInsets.only(top: 80),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: !istwoperson
                          ? Text("$keteranganz")
                          : Text(
                              "pastikan tidak ada wajah lain",
                              textAlign: TextAlign.center,
                            ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: Column(
                children: [
                  Row(
                    children: [Icon(Icons.face), Text("yes")],
                  )
                ],
              )),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.75,
                ),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis
                      .horizontal, // Membuat list menggulir secara horizontal
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
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 6,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}
