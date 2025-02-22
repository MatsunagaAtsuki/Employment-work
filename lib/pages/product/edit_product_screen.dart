import 'package:flutter/material.dart';

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
  String? selectedCategory;
  String? selectedSupplier;
  List<String> categories = ["カテゴリA", "カテゴリB", "カテゴリC"];
  List<String> suppliers = ["サプライヤーX", "サプライヤーY", "サプライヤーZ"];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.productData['name']);
    barcodeController = TextEditingController(text: widget.productData['barcode']);
    priceController = TextEditingController(text: widget.productData['price'].toString());
    stockController = TextEditingController(text: widget.productData['stock'].toString());
    selectedCategory = widget.productData['category_id']?.toString();
    selectedSupplier = widget.productData['supplier_id']?.toString();
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
              Text("商品名: ${widget.productData['name']} → ${nameController.text}"),
              Text("バーコード: ${widget.productData['barcode']} → ${barcodeController.text}"),
              Text("価格: ¥${widget.productData['price']} → ¥${priceController.text}"),
              Text("在庫数: ${widget.productData['stock']} → ${stockController.text}"),
              Text("カテゴリ: ${widget.productData['category_id']} → ${selectedCategory ?? '未分類'}"),
              Text("仕入先: ${widget.productData['supplier_id']} → ${selectedSupplier ?? '不明'}"),
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

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("商品が更新されました")),
      );
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
