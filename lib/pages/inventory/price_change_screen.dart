import 'package:flutter/material.dart';

class PriceChangeScreen extends StatelessWidget {
  final String productId;

  const PriceChangeScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController priceController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("売価変更")),
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
                labelText: "新しい売価",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newPrice = priceController.text;
                if (newPrice.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("売価を $newPrice 円に変更しました")),
                  );
                }
              },
              child: const Text("売価を変更"),
            ),
          ],
        ),
      ),
    );
  }
}
