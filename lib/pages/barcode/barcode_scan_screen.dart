import 'dart:io';
import 'dart:convert'; // HTTPレスポンスのJSONデコード用
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:inventory_manager/pages/inventory/price_change_screen.dart';
import 'package:inventory_manager/pages/inventory/schedule_screen.dart';
import 'package:http/http.dart' as http; // HTTPリクエスト用

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
  Map<String, String> scheduleData = {};

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

  // Flaskバックエンド経由で製品情報を取得する
  Future<void> fetchProductData(String barcode) async {
    if (barcode.isEmpty) return;

    setState(() {
      barcodeData = barcode;
      isLoading = true;
    });

    // バックエンドURLを「http://127.0.0.1:5000」に統一
    final url = 'http://127.0.0.1:5000/api/products/lookup?barcode=$barcode';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // 受け取ったデータをMap<String, String>へ変換
          productData = Map<String, String>.from(
              data.map((key, value) => MapEntry(key, value.toString())));
          isLoading = false;
          hasScanned = true;
        });
        // 製品IDがある場合、スケジュール情報も取得
        if (productData.containsKey("商品ID")) {
          fetchScheduleData(productData["商品ID"]!);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('製品情報の取得に失敗しました。')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('エラーが発生しました。')),
      );
    }
  }

  // 製品IDからスケジュール情報を取得する
  Future<void> fetchScheduleData(String productId) async {
    final url = 'http://127.0.0.1:5000/api/schedule/lookup?productId=$productId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // スケジュールが存在する場合、scheduleDataに格納
        if (data is Map && data.containsKey('message')) {
          setState(() {
            scheduleData = {};
          });
        } else {
          setState(() {
            scheduleData = Map<String, String>.from(
                data.map((key, value) => MapEntry(key, value.toString())));
          });
        }
      } else {
        setState(() {
          scheduleData = {};
        });
      }
    } catch (e) {
      setState(() {
        scheduleData = {};
      });
    }
  }

  void startScanning() {
    setState(() {
      hasScanned = false;
      productData.clear();
      scheduleData.clear();
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
                      if (barcode.rawValue != null &&
                          barcode.rawValue!.isNotEmpty) {
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 製品情報表示（created_at, updated_atは除外）
                            ...productData.entries
                                .where((entry) =>
                                    entry.key != 'created_at' &&
                                    entry.key != 'updated_at')
                                .map((entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                            const Divider(),
                            // スケジュール情報が存在する場合、表示（新しい価格, 開始日時, 終了日時 のみ）
                            if (scheduleData.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "スケジュール情報",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // 指定した順序に従って表示
                                  ...["new_price", "start_date", "end_date"]
                                      .where((key) =>
                                          scheduleData.containsKey(key))
                                      .map((key) {
                                    String label = "";
                                    if (key == "new_price") {
                                      label = "新しい価格";
                                    } else if (key == "start_date") {
                                      label = "開始日時";
                                    } else if (key == "end_date") {
                                      label = "終了日時";
                                    }
                                    String value = scheduleData[key]!;
                                    if (value.contains('T')) {
                                      value = value.replaceAll('T', '/');
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "$label:",
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              value,
                                              textAlign: TextAlign.left,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              )
                          ],
                        ),
                      ),
                      // スケジュール作成ボタン（カード下部に配置）
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScheduleScreen(
                                  productId: productData["商品ID"]!,
                                  productName: productData["商品名"]!,
                                  productPrice: productData["価格"]!,
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
