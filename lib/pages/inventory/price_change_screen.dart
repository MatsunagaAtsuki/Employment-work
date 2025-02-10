import 'package:flutter/material.dart';

class PriceChangeScreen extends StatefulWidget {
  final String productId;
  final String productName;
  const PriceChangeScreen({super.key, required this.productId, required this.productName});

  @override
  _PriceChangeScreenState createState() => _PriceChangeScreenState();
}

class _PriceChangeScreenState extends State<PriceChangeScreen> {
  final TextEditingController _newPriceController = TextEditingController();
  double? currentPrice = 50000.00; // 仮の現在価格（バックエンドと接続時に取得）

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("売価変更")),
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
                _buildTableRow("商品名", widget.productName),
                _buildTableRow("商品ID", widget.productId),
                _buildTableRow("現在の価格", "¥${currentPrice?.toStringAsFixed(2) ?? '取得中'}"),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "新しい価格",
                prefixText: "¥",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showConfirmationDialog,
                child: const Text("変更を確定"),
              ),
            ),
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

  void _showConfirmationDialog() {
    String newPrice = _newPriceController.text;
    if (newPrice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("新しい価格を入力してください")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("価格変更の確認"),
        content: Text("商品名: ${widget.productName}\n現在の価格: ¥${currentPrice?.toStringAsFixed(2)}\n新しい価格: ¥$newPrice\n\n変更を確定しますか？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("キャンセル"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyPriceChange(newPrice);
            },
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }

  void _applyPriceChange(String newPrice) {
    setState(() {
      currentPrice = double.tryParse(newPrice.replaceAll(",", "")) ?? currentPrice;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("価格が ¥${currentPrice?.toStringAsFixed(2)} に更新されました")),
    );
  }
}
