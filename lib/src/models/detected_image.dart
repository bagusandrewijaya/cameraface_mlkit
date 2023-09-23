import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DetectedFace {
  final Face? face;
  final bool wellPositioned;
  final String data;
  final bool muka;
  const DetectedFace(
      {required this.muka,required this.data, required this.face, required this.wellPositioned});

  DetectedFace copyWith({Face? face, bool? wellPositioned}) => DetectedFace(
    muka: muka,
      face: face ?? this.face,
      wellPositioned: wellPositioned ?? this.wellPositioned,
      data: data);
}
