import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Map<String, int> orderQuantities;
  final List<Map<String, dynamic>> productList;

  const OrderConfirmationScreen({
    super.key,
    required this.orderQuantities,
    required this.productList,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> orderedItems = productList.where((item) {
      return orderQuantities[item["商品ID"]] != null && orderQuantities[item["商品ID"]]! > 0;
    }).toList();

    int totalAmount = orderedItems.fold(0, (sum, item) {
      double price = double.tryParse(item["価格"].toString()) ?? 0.0;
      int quantity = orderQuantities[item["商品ID"]]!;
      return sum + (price * quantity).toInt();
    });

    return Scaffold(
      appBar: AppBar(title: const Text("発注確認")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: orderedItems.length,
                itemBuilder: (context, index) {
                  var item = orderedItems[index];
                  int quantity = orderQuantities[item["商品ID"]]!;
                  double price = double.tryParse(item["価格"].toString()) ?? 0.0;
                  int totalPrice = (price * quantity).toInt();
                  return Card(
                    child: ListTile(
                      title: Text(item["商品名"]),
                      subtitle: Text("数量: $quantity 個 - ¥$totalPrice"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text("合計金額: ¥$totalAmount",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("発注確定"),
            ),
          ],
        ),
      ),
    );
  }
}
