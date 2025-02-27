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
            if (hasScanned)
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
                child: Column(
                  children: productData.entries.map((entry) => Text("${entry.key}: ${entry.value}"))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
