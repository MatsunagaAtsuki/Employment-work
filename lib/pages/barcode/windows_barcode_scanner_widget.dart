// // windows_barcode_scanner_widget.dart
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:zxing2/zxing2.dart' as ZXing;

// class WindowsBarcodeScannerWidget extends StatefulWidget {
//   final Function(String barcode) onBarcodeDetected;

//   const WindowsBarcodeScannerWidget({Key? key, required this.onBarcodeDetected}) : super(key: key);

//   @override
//   _WindowsBarcodeScannerWidgetState createState() => _WindowsBarcodeScannerWidgetState();
// }

// class _WindowsBarcodeScannerWidgetState extends State<WindowsBarcodeScannerWidget> {
//   String? scannedBarcode;

//   Future<void> _pickAndScanImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null && result.files.single.path != null) {
//       File file = File(result.files.single.path!);
//       Uint8List bytes = await file.readAsBytes();

//       // 画像をデコード
//       img.Image? image = img.decodeImage(bytes);
//       if (image == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("画像の読み込みに失敗しました。")),
//         );
//         return;
//       }

//       // 画像のピクセルデータを取得し Int32List に変換
//       List<int> pixelList = image.getBytes();
//       Int32List pixels = Int32List.fromList(pixelList);

//       try {
//         // RGBLuminanceSource、BinaryBitmap、HybridBinarizer の生成
//         final luminanceSource = ZXing.RGBLuminanceSource(image.width, image.height, pixels);
//         final binaryBitmap = ZXing.BinaryBitmap(ZXing.HybridBinarizer(luminanceSource));
//         // MultiFormatReader のインスタンスを生成してデコード
//         final reader = ZXing.MultiFormatReader();
//         final result = reader.decode(binaryBitmap);
//         setState(() {
//           scannedBarcode = result.text;
//         });
//         widget.onBarcodeDetected(result.text);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("バーコードの読み取りに失敗しました: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (scannedBarcode != null)
//           Text("Scanned Barcode: $scannedBarcode"),
//         ElevatedButton(
//           onPressed: _pickAndScanImage,
//           child: const Text("画像を選択してバーコードを読み込む"),
//         ),
//       ],
//     );
//   }
// }
