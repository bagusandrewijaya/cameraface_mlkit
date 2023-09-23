import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../models/detected_image.dart';

class FaceIdentifier {
  static Future<DetectedFace?> scanImage(
      {required CameraImage cameraImage,
      required CameraDescription camera}) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final InputImageFormat inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
            InputImageFormat.nv21;

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final visionImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    DetectedFace? result;
    final face = await _detectFace(visionImage: visionImage);
    if (face != null) {
      result = face;
    }

    return result;
  }

  static Future<DetectedFace?> _detectFace({required visionImage}) async {
    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    try {
      final List<Face> faces = await faceDetector.processImage(visionImage);
      final faceDetect = _extractFace(faces);
      return faceDetect;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  static _extractFace(List<Face> faces) {
    //List<Rect> rect = [];
    bool wellPositioned = faces.isNotEmpty;
    Face? detectedFace;
    String menghadap = '';
    bool terdapatLebihDariSatuWajah = faces.length > 1;
    for (Face face in faces) {
      // rect.add(face.boundingBox);
      detectedFace = face;

      // Head is rotated to the right rotY degrees
      if (face.headEulerAngleY! > 10) {
        menghadap = "Menghadap Kiri";
      } else if (face.headEulerAngleY! < -5) {
        menghadap = "Menghadap Kanan";
      } else {
        menghadap = "Tidak Menghadap Kiri atau Kanan";
      }

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):

      if (face.leftEyeOpenProbability != null) {
        if (face.leftEyeOpenProbability! < 4) {
          wellPositioned = false;
        }
      }

      if (face.rightEyeOpenProbability != null) {
        if (face.rightEyeOpenProbability! < 4) {
          wellPositioned = false;
        }
      }
    }

    return DetectedFace(
        wellPositioned: wellPositioned,
        face: detectedFace,
        data: menghadap,
        muka: terdapatLebihDariSatuWajah);
  }
}
