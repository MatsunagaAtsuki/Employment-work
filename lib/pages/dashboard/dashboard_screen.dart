import 'package:flutter/material.dart';
import '../../utils/appbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // 画面の横幅を取得
    double screenWidth = MediaQuery.of(context).size.width;

    // 横幅に基づいてサイズを決定
    double boxSize = screenWidth < 600 ? 150 : 200;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  title: "機能 $i",
                  onTap: () {
                    // カードクリック時の動作
                    print("機能 $i がクリックされました");
                  },
                  boxSize: boxSize,
                ),
            ],
          ),
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
