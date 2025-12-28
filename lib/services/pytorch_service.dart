import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pytorch_lite/flutter_pytorch_lite.dart';

class PytorchService {
  static Module? _module;

  /// โหลดโมเดลครั้งเดียว
  static Future<Module> loadModel() async {
    if (_module != null) return _module!;

    final byteData = await rootBundle.load(
      'assets/models/quran_recitation_model.ptl',
    );

    final tempDir = await getTemporaryDirectory();
    final modelPath = '${tempDir.path}/quran_recitation_model.ptl';

    final file = File(modelPath);
    await file.writeAsBytes(
      byteData.buffer.asUint8List(),
      flush: true,
    );

    _module = await FlutterPytorchLite.load(modelPath);
    return _module!;
  }

  /// คืนหน่วยความจำ
  static void dispose() {
    _module?.destroy();
    _module = null;
  }
}

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_pytorch_lite/flutter_pytorch_lite.dart';

// class PytorchService {
//   static Module? _module;

//   /// โหลดโมเดล
//   static Future<Module> loadModel() async {
//     if (_module != null) return _module!;

//     final byteData = await rootBundle.load(
//       'assets/models/quran_recitation_model.ptl',
//     );

//     final tempDir = await getTemporaryDirectory();
//     final modelPath = '${tempDir.path}/quran_recitation_model.ptl';

//     final file = File(modelPath);
//     await file.writeAsBytes(
//       byteData.buffer.asUint8List(),
//       flush: true,
//     );

//     _module = await FlutterPytorchLite.load(modelPath);
//     return _module!;
//   }

//   /// 🔥 Inference (เรียกใช้จาก screen)
//   static Future<List<double>> runInference(List<double> mfcc) async {
//     final module = await loadModel();

//     final tensor = Tensor.fromBlobFloat32(
//       mfcc,
//       Int64List.fromList([1, 1, 98, 40]), // ⚠️ ต้องตรงกับตอน train
//     );

//     final output = await module.forward([
//       IValue.from(tensor),
//     ]);

//     return output.toTensor().dataAsFloat32List;
//   }

//   /// คืนหน่วยความจำ
//   static void dispose() {
//     _module?.destroy();
//     _module = null;
//   }
// }
