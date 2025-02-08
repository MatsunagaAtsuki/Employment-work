import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BarcodeScannerScreen(),
    );
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String barcodeData = "バーコードをスキャンしてください";
  String productName = "";
  String productPrice = "";
  final MobileScannerController scannerController = MobileScannerController();
  bool isScanning = false;

  Future<void> fetchProductData(String barcode) async {
    setState(() {
      barcodeData = barcode; // スキャン結果を即表示
    });
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getProductByBarcode');
      final response = await callable.call({'barcode': barcode});

      setState(() {
        productName = response.data['name'];
        productPrice = response.data['price'].toString();
      });
    } catch (e) {
      setState(() {
        productName = "商品が見つかりません";
        productPrice = "";
      });
    }
  }

  void startScan() {
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
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: scannerController,
              onDetect: (capture) {
                if (!isScanning) return;
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
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
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("バーコード: $barcodeData", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("商品名: $productName", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("価格: ¥$productPrice", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isScanning ? null : startScan,
                    child: const Text("スキャン開始"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}
