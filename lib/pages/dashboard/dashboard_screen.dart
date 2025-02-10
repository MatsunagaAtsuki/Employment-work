import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/barcode/barcode_scan_screen.dart';
import 'package:inventory_manager/pages/product/allproduct.dart';
import 'package:inventory_manager/pages/order/order.dart';
import 'package:inventory_manager/pages/shipment/shipment.dart';
import 'package:inventory_manager/utils/appbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = screenWidth < 600 ? 150 : 200;

    return Scaffold(
      appBar: const CustomAppBar(title: "在庫管理アプリケーション"),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _buildDashboardCard(
              title: "バーコードスキャン",
              icon: Icons.qr_code_scanner,
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
              icon: Icons.list,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllProductScreen()),
                );
              },
              boxSize: boxSize,
            ),
            _buildDashboardCard(
              title: "発注画面",
              icon: Icons.shopping_cart,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderScreen()),
                );
              },
              boxSize: boxSize,
            ),
            _buildDashboardCard(
              title: "出庫（販売）",
              icon: Icons.local_shipping,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShipmentScreen()),
                );
              },
              boxSize: boxSize,
            ),
          ],
        ),
      ),
    );
  }

  // アイコンカードを作成するウィジェット
  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
