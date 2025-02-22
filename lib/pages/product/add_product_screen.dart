import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String? selectedCategory;
  String? selectedSupplier;
  List<String> categories = ["電子機器", "PC・周辺機器", "オーディオ"];
  List<String> suppliers = ["テスト商社", "サプライヤーA", "サプライヤーB"];

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String barcode = _barcodeController.text;
      double price = double.parse(_priceController.text);
      int stock = int.parse(_stockController.text);
      String category = selectedCategory ?? "未分類";
      String supplier = selectedSupplier ?? "不明";

      // 仮データ挿入処理（実際にはAPI経由でデータベースに送信）
      print("商品追加: 名前=$name, バーコード=$barcode, 価格=¥$price, 在庫=$stock, カテゴリ=$category, 仕入先=$supplier");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("商品が追加されました")),
      );

      // 入力欄をクリア
      _nameController.clear();
      _barcodeController.clear();
      _priceController.clear();
      _stockController.clear();
      setState(() {
        selectedCategory = null;
        selectedSupplier = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("商品追加")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "商品名", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "商品名を入力してください" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(labelText: "バーコード", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "価格", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "価格を入力してください" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "在庫数", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "在庫数を入力してください" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "カテゴリ", border: OutlineInputBorder()),
                value: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value),
                items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "仕入先", border: OutlineInputBorder()),
                value: selectedSupplier,
                onChanged: (value) => setState(() => selectedSupplier = value),
                items: suppliers.map((supplier) => DropdownMenuItem(value: supplier, child: Text(supplier))).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProduct,
                child: const Text("商品を追加"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
