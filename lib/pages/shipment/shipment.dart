import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShipmentScreen extends StatefulWidget {
  const ShipmentScreen({super.key});

  @override
  _ShipmentScreenState createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "すべて";
  List<Map<String, dynamic>> productList = [];
  List<String> categories = ["すべて"];
  Map<String, int> shipmentQuantities = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // DB の商品テーブルからデータを取得する処理
  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    // バックエンドのGET /api/products エンドポイント
    String url = 'http://127.0.0.1:5000/api/products';
    //String url = 'http://10.0.2.2:5000/api/products';
    if (selectedCategory != "すべて") {
      url += '?category=$selectedCategory';
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> loadedProducts =
            data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
        // カテゴリのセット更新
        Set<String> categorySet = {"すべて"};
        for (var product in loadedProducts) {
          if (product.containsKey("カテゴリーネーム")) {
            categorySet.add(product["カテゴリーネーム"]);
          }
        }
        setState(() {
          productList = loadedProducts;
          categories = categorySet.toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("商品一覧の取得に失敗しました。")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("エラーが発生しました。")),
      );
    }
  }

// 出庫内容をまとめ、バックエンドに出庫リクエストを送信する
Future<void> _processShipment() async {
  // 出庫数量が0より大きい商品のみを抽出
  List<Map<String, dynamic>> shipmentItems = [];
  for (var item in productList) {
    String productId = item["商品ID"];
    int quantity = shipmentQuantities[productId] ?? 0;
    if (quantity > 0) {
      // 在庫数を取得（在庫数が文字列の場合は int に変換）
      int availableStock = int.tryParse(item["在庫数"].toString()) ?? 0;
      if (quantity > availableStock) {
        // 出庫数量が在庫数を超えている場合はアラートを出して処理中断
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${item["商品名"]}の出庫数 ($quantity) が在庫数 ($availableStock) を超えています。"),
          ),
        );
        return;
      }
      shipmentItems.add({
        "productId": productId,
        "quantity": quantity,
      });
    }
  }
  if (shipmentItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("出庫する商品が選択されていません。")),
    );
    return;
  }
  String url = 'http://127.0.0.1:5000/api/shipment';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"shipmentItems": shipmentItems}),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("出庫が確定しました")),
      );
      setState(() {
        shipmentQuantities.clear();
      });
      // 再取得して最新在庫を反映する場合は、_loadProducts() を呼ぶ
      _loadProducts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("出庫処理に失敗しました: ${response.body}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("出庫処理中にエラーが発生しました。")),
    );
  }
}


void _showShipmentSummaryDialog() {
  List<Map<String, dynamic>> shippedItems = productList.where((item) {
    return shipmentQuantities[item["商品ID"]] != null &&
           shipmentQuantities[item["商品ID"]]! > 0;
  }).toList();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("出庫確認"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: shippedItems.map((item) {
          int quantity = shipmentQuantities[item["商品ID"]]!;
          // 価格の文字列から数字のみ抽出して変換する
          String priceStr = item["価格"].toString();
          // 数字とドット以外を除去
          priceStr = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
          double price = double.tryParse(priceStr) ?? 0.0;
          int totalPrice = (price * quantity).toInt();
          return Text("${item["商品名"]}: $quantity 個 - ¥$totalPrice");
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("キャンセル"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _processShipment();
          },
          child: const Text("確定"),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = productList.where((product) {
      return (selectedCategory == "すべて" || product["カテゴリーネーム"] == selectedCategory) &&
             (product["商品名"].contains(_searchController.text) ||
              product["商品ID"].contains(_searchController.text));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("出庫画面")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "商品検索",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => setState(() {}),
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "カテゴリでソート",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                        _loadProducts(); // カテゴリ変更時に再取得
                      }
                    },
                    items: categories.map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        var item = filteredList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(item["商品名"]),
                            subtitle: Text("価格: ¥${item["価格"]}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (shipmentQuantities[item["商品ID"]] != null &&
                                          shipmentQuantities[item["商品ID"]]! > 0) {
                                        shipmentQuantities[item["商品ID"]] =
                                            shipmentQuantities[item["商品ID"]]! - 1;
                                      }
                                    });
                                  },
                                ),
                                Text(shipmentQuantities[item["商品ID"]]?.toString() ?? "0"),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      shipmentQuantities[item["商品ID"]] =
                                          (shipmentQuantities[item["商品ID"]] ?? 0) + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _showShipmentSummaryDialog,
                    child: const Text("出庫確定"),
                  ),
                ],
              ),
            ),
    );
  }
}
