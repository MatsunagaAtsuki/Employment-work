import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/darcode/barcode_scan_screen.dart';
import 'package:inventory_manager/utils/appbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<dynamic> data;  // MySQLから取得したデータ

  @override
  void initState() {
    super.initState();
    data = [];
  }

  // Firebase Functionsからデータを取得
  Future<void> _fetchDataFromFirebase() async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getDataFromMySQL');
      final response = await callable.call();
      setState(() {
        data = response.data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

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
            // カードを複数生成
            for (var i = 1; i <= 10; i++)
              _buildDashboardCard(
                title: i == 1 ? "バーコードスキャン" : "機能 $i",
                onTap: () {
                  if (i == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
                    );
                  } else if (i == 2) {
                    // 機能2がクリックされたらFirebase Functionsを呼び出す
                    _fetchDataFromFirebase();
                  } else {
                    print("機能 $i がクリックされました");
                  }
                },
                boxSize: boxSize,
              ),
            // データ表示
            if (data.isNotEmpty)
              Column(
                children: data.map((item) {
                  return ListTile(
                    title: Text("Item: ${item['your_column_name']}"),  // データに合わせてカラム名を変更
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // アイコンカードを作成するウィジェット
  Widget _buildDashboardCard(
      {required String title,
      required VoidCallback onTap,
      required double boxSize}) {
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
