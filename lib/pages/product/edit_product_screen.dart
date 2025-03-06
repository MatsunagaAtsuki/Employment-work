import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const EditProductScreen({super.key, required this.productData});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController barcodeController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.productData['商品名']);
    barcodeController = TextEditingController(text: widget.productData['JANコード']);
    priceController = TextEditingController(text: widget.productData['価格'].toString());
    stockController = TextEditingController(text: widget.productData['在庫数'].toString());
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("変更の確認"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("商品名: ${widget.productData['商品名']} → ${nameController.text}"),
              Text("バーコード: ${widget.productData['JANコード']} → ${barcodeController.text}"),
              Text("価格: ¥${widget.productData['価格']} → ¥${priceController.text}"),
              Text("在庫数: ${widget.productData['在庫数']} → ${stockController.text}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("キャンセル"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProduct();
                Navigator.pop(context);
              },
              child: const Text("確定"),
            ),
          ],
        );
      },
    );
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      // 更新する内容をペイロードにまとめる（カテゴリー・仕入先は含めない）
      Map<String, dynamic> payload = {
        "productId": widget.productData['商品ID'],
        "name": nameController.text,
        "barcode": barcodeController.text,
        "price": double.tryParse(priceController.text),
        "stock": int.tryParse(stockController.text),
      };
      // バックエンドURL（実行環境に合わせて必要なら変更）
      String url = 'http://127.0.0.1:5000/api/products/update';
      try {
        final response = await http.put(Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json.encode(payload));
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("商品が更新されました")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("更新に失敗しました: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("エラーが発生しました。")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("商品編集")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "商品名", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "商品名を入力してください" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: barcodeController,
                decoration: const InputDecoration(labelText: "バーコード", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "価格", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "価格を入力してください" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "在庫数", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "在庫数を入力してください" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showPreviewDialog,
                child: const Text("商品を更新"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
