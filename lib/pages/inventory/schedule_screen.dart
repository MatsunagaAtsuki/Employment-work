import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  final String productId;

  const ScheduleScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController priceController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("売価スケジュール作成")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("商品ID: $productId", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "設定する売価",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "適用開始日 (YYYY-MM-DD)",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newPrice = priceController.text;
                String startDate = dateController.text;
                if (newPrice.isNotEmpty && startDate.isNotEmpty) {
                  // ここでFirebaseやDB更新処理を実装
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("売価を $newPrice 円に設定 (適用開始日: $startDate)")),
                  );
                }
              },
              child: const Text("スケジュールを設定"),
            ),
          ],
        ),
      ),
    );
  }
}
