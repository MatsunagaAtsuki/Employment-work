import 'package:flutter/material.dart';
import 'order_confirmation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "すべて";
  List<Map<String, dynamic>> productList = [];
  List<String> categories = ["すべて"];
  Map<String, int> orderQuantities = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // モックデータではなく、DB の商品テーブルからデータを取得する
  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
    // バックエンドURL（実行環境に合わせて変更してください）
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
        // カテゴリのセットを更新
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = selectedCategory == "すべて"
        ? productList
        : productList.where((p) => p["カテゴリーネーム"] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("発注画面")),
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
                                      if (orderQuantities[item["商品ID"]] != null &&
                                          orderQuantities[item["商品ID"]]! > 0) {
                                        orderQuantities[item["商品ID"]] =
                                            orderQuantities[item["商品ID"]]! - 1;
                                      }
                                    });
                                  },
                                ),
                                Text(orderQuantities[item["商品ID"]]?.toString() ?? "0"),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      orderQuantities[item["商品ID"]] =
                                          (orderQuantities[item["商品ID"]] ?? 0) + 1;
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(
                            orderQuantities: orderQuantities,
                            productList: productList,
                            
                          ),
                        ),
                      );
                    },
                    child: const Text("発注確認"),
                  ),
                ],
              ),
            ),
    );
  }
}
