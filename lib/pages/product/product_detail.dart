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
      appBar: AppBar(title: Text(productData["商品名"]!)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("商品ID:", textAlign: TextAlign.right, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(productData["商品ID"], style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("JANコード:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(productData["JANコード"], style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("価格:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(productData["価格"], style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("在庫数:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(productData["在庫数"], style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToLogin(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("商品編集", style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
