import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/inventory/price_change_screen.dart';
import 'package:inventory_manager/pages/inventory/schedule_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    // 価格データを double に変換（数値である場合のみ）
    double? price = double.tryParse(
        productData["価格"].toString().replaceAll("¥", "").replaceAll(",", ""));

    return Scaffold(
      appBar: AppBar(title: Text(productData["商品名"]!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FixedColumnWidth(120),
                1: FlexColumnWidth(),
              },
              children: [
                _buildTableRow("商品名", productData["商品名"]),
                _buildTableRow("商品ID", productData["商品ID"]),
                _buildTableRow("JANコード", productData["JANコード"]),
                _buildTableRow("価格", "¥${price != null ? price.toStringAsFixed(2) : productData["価格"]}"),
                _buildTableRow("在庫数", productData["在庫数"]),
                _buildTableRow("カテゴリーID", productData["カテゴリーID"]),
                _buildTableRow("カテゴリーネーム", productData["カテゴリーネーム"]),
                _buildTableRow("仕入先ID", productData["仕入先ID"]),
              ],
            ),
            const SizedBox(height: 20),
            
            // ** 売価変更 & 売価スケジュール作成ボタン **
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PriceChangeScreen(
                          productId: productData["商品ID"].toString(),
                          productName: productData["商品名"], // 商品名を追加
                        ),
                      ),
                    );
                  },
                  child: const Text("売価変更"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                          productId: productData["商品ID"].toString(),
                          productName: productData["商品名"], // 商品名を渡す
                        ),
                      ),
                    );
                  },
                  child: const Text("売価スケジュール作成"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: const Text("戻る"),
            // ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value.toString(), style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
