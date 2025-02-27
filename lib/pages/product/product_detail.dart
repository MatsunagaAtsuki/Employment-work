import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/product/edit_product_screen.dart';
import 'package:inventory_manager/pages/login/admin_login_page.dart';
import 'package:inventory_manager/pages/order/order.dart';
import 'package:inventory_manager/pages/inventory/admin_schedule_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailScreen({super.key, required this.productData});

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminLoginPage(onLoginSuccess: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProductScreen(productData: productData)),
        );
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productData["商品名"] ?? "不明")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("商品名", productData["商品名"] ?? "不明"),
                    _buildInfoRow("カテゴリ", productData["カテゴリ"] ?? "不明"),
                    _buildInfoRow("商品ID", productData["商品ID"] ?? "不明"),
                    _buildInfoRow("JANコード", productData["JANコード"] ?? "不明"),
                    _buildInfoRow("価格", "¥${productData["価格"] ?? "不明"}"),
                    _buildInfoRow("在庫数", productData["在庫数"] ?? "不明"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text("発注", style: TextStyle(fontSize: 18)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminLoginPage(
                          onLoginSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminScheduleScreen(
                                  productData: productData,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text("スケジュール作成", style: TextStyle(fontSize: 18)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToLogin(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text("商品編集", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
