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
  final MobileScannerController scannerController = MobileScannerController();
  final TextEditingController barcodeController = TextEditingController();

  bool isScanning = false;
  bool isLoading = false;
  String barcodeData = "";
  Map<String, String> productData = {};

  bool get isMobile => Platform.isAndroid || Platform.isIOS;

  Future<void> fetchProductData(String barcode) async {
    if (barcode.isEmpty) return;

    setState(() {
      barcodeData = barcode;
      isLoading = true;
    });

    // 仮データを使用
    await Future.delayed(const Duration(seconds: 1)); // 1秒の遅延（API風）
    setState(() {
      productData = {
        "商品ID": "12345",
        "商品名": "テスト商品",
        "カテゴリ名": "電子機器",
        "価格": "¥2,980",
        "在庫数": "20",
        "仕入先名": "テスト商社",
      };
      isLoading = false;
    });
  }

  void startScan() {
    if (!isMobile) return;
    setState(() {
      isScanning = true;
    });
    scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("バーコードスキャナー")),
      body: Column(
        children: [
          if (isMobile)
            Expanded(
              flex: 3,
              child: MobileScanner(
                controller: scannerController,
                onDetect: (capture) {
                  if (!isScanning) return;
                  for (final barcode in capture.barcodes) {
                    if (barcode.rawValue != null) {
                      setState(() {
                        isScanning = false;
                      });
                      fetchProductData(barcode.rawValue!);
                      scannerController.stop();
                    }
                  }
                },
              ),
            ),
          // バーコード手入力欄
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
          // **売価変更 & スケジュールボタン**
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
                                builder: (context) => PriceChangeScreen(productId: productData["商品ID"]!),
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
                                builder: (context) => ScheduleScreen(productId: productData["商品ID"]!),
                              ),
                            );
                          }
                        : null,
                    child: const Text("売価スケジュール作成"),
                  ),
                ],
              ),
            ),
          // **データ表示エリア**
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : buildProductInfoTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductInfoTable() {
    if (productData.isEmpty) {
      return const Center(child: Text("商品情報を取得してください"));
    }

    return Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: productData.entries
          .map((entry) => _buildTableRow(entry.key, entry.value))
          .toList(),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (isMobile) scannerController.dispose();
    barcodeController.dispose();
    super.dispose();
  }
}
