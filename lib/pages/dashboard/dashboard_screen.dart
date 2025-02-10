import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/barcode/barcode_scan_screen.dart';
import 'package:inventory_manager/pages/product/allproduct.dart';
import 'package:inventory_manager/utils/appbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, String>> data = []; // 仮データリスト

  @override
  void initState() {
    super.initState();
    _loadMockData(); // 仮データを読み込む
  }

  void _loadMockData() {
    // 仮データを設定
    setState(() {
      data = [
        {"商品ID": "1001", "商品名": "スマートフォン", "価格": "¥50,000", "在庫数": "15"},
        {"商品ID": "1002", "商品名": "ノートPC", "価格": "¥120,000", "在庫数": "8"},
        {"商品ID": "1003", "商品名": "ワイヤレスイヤホン", "価格": "¥9,800", "在庫数": "30"},
        {"商品ID": "1004", "商品名": "スマートウォッチ", "価格": "¥25,000", "在庫数": "12"},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = screenWidth < 600 ? 150 : 200;

    return Scaffold(
      appBar: const CustomAppBar(title: "在庫管理アプリケーション"),
      body: Center(
        child: Column(
          children: [
            // ボタンエリア
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildDashboardCard(
                  title: "バーコードスキャン",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
                    );
                  },
                  boxSize: boxSize,
                ),
                _buildDashboardCard(
                  title: "商品一覧",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllProductScreen()),
                    );
                  },
                  boxSize: boxSize,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // データ表示エリア
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var item = data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(item["商品名"]!),
                      subtitle: Text("価格: ${item["価格"]} | 在庫数: ${item["在庫数"]}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // 商品の詳細ページに遷移する場合の処理
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // アイコンカードを作成するウィジェット
  Widget _buildDashboardCard({
    required String title,
    required VoidCallback onTap,
    required double boxSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: boxSize,
        width: boxSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 195, 195, 195),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
