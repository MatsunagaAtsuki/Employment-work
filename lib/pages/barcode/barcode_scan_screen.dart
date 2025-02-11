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
  String barcodeData = "";
  Map<String, String> productData = {};

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("バーコードスキャナー")),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      fetchProductData(barcodeController.text);
                    },
                    child: const Text("検索"),
                  ),
                ],
              ),
            ),
            if (productData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: productData["商品ID"] != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PriceChangeScreen(
                                    productId: productData["商品ID"]!,
                                    productName: productData["商品名"]!,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text("売価変更"),
                    ),
                    ElevatedButton(
                      onPressed: productData["商品ID"] != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleScreen(
                                    productId: productData["商品ID"]!,
                                    productName: productData["商品名"]!,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: const Text("売価スケジュール作成"),
                    ),
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : buildProductInfoTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductInfoTable() {
    if (productData.isEmpty) {
      return const Center(child: Text("商品情報を取得してください"));
    }

    return Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      children: productData.entries.map((entry) => _buildTableRow(entry.key, entry.value)).toList(),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(label)),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(value)),
      ],
    );
  }
}
