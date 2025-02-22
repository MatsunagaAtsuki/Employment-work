import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/product/edit_product_screen.dart';
import 'package:inventory_manager/pages/login/admin_login_page.dart';

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
      appBar: AppBar(title: Text(productData["商品名"]!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("商品ID: ${productData["商品ID"]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("JANコード: ${productData["JANコード"]}", style: const TextStyle(fontSize: 16)),
            Text("価格: ¥${productData["価格"]}", style: const TextStyle(fontSize: 16)),
            Text("在庫数: ${productData["在庫数"]}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToLogin(context),
                child: const Text("商品編集"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
