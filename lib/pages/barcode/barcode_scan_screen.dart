import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:inventory_manager/pages/inventory/price_change_screen.dart';
import 'package:inventory_manager/pages/inventory/schedule_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController scannerController = MobileScannerController(
    formats: [BarcodeFormat.qrCode, BarcodeFormat.ean13, BarcodeFormat.upcA],
    detectionSpeed: DetectionSpeed.normal,
    autoStart: true,
  );

  final TextEditingController barcodeController = TextEditingController();
  bool isLoading = false;
  bool isCameraAvailable = true;
  bool hasScanned = false;
  String barcodeData = "";
  Map<String, String> productData = {};

  @override
  void initState() {
    super.initState();
    _checkCameraAvailability();
  }

  void _checkCameraAvailability() {
    setState(() {
      isCameraAvailable = Platform.isAndroid || Platform.isIOS;
    });
  }

  Future<void> fetchProductData(String barcode) async {
    if (barcode.isEmpty) return;

    setState(() {
      barcodeData = barcode;
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      productData = {
        "商品ID": "12345",
        "商品名": "テスト商品",
        "JANコード": "4912345678911",
        "カテゴリ名": "電子機器",
        "価格": "¥50,000",
        "在庫数": "20",
        "仕入先名": "テスト商社",
      };
      isLoading = false;
      hasScanned = true;
    });
  }

  void startScanning() {
    setState(() {
      hasScanned = false;
      productData.clear();
    });
    scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("バーコードスキャナー")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isCameraAvailable && !hasScanned)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: MobileScanner(
                  controller: scannerController,
                  onDetect: (capture) {
                    for (final barcode in capture.barcodes) {
                      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                        fetchProductData(barcode.rawValue!);
                        scannerController.stop();
                        break;
                      }
                    }
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "この端末ではカメラを使用できません。バーコードを手入力してください。",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: barcodeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "バーコード",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            fetchProductData(barcodeController.text);
                          },
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        fetchProductData(value);
                      },
                    ),
                  ],
                ),
              ),
            if (hasScanned && isCameraAvailable)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: startScanning,
                  child: const Text("再スキャン"),
                ),
              ),
            if (productData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productData.entries.map((entry) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${entry.key}:",
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        entry.value,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScheduleScreen(
                                  productId: productData["商品ID"]!,
                                  productName: productData["商品名"]!,
                                ),
                              ),
                            );
                          },
                          child: const Text("スケジュール作成"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
