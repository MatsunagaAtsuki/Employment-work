import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/product/product_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<Map<String, String>> productList = [];
  String selectedCategory = "すべて";
  List<String> categories = ["すべて"];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProducts(); // バックエンドから商品一覧を取得
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    // バックエンドURLを統一：127.0.0.1:5000/api/products
    String url = 'http://127.0.0.1:5000/api/products';
    //String url = 'http://10.0.2.2:5000/api/products';
    //String url = 'http://192.168.56.1:5000/api/products';
    
    if (selectedCategory != "すべて") {
      url += '?category=$selectedCategory';
    }
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> loadedProducts =
            data.map<Map<String, String>>(
              (item) => Map<String, String>.from(item),
            ).toList();
        // カテゴリのセットを更新
        Set<String> categorySet = {"すべて"};
        for (var product in loadedProducts) {
          if (product.containsKey("カテゴリーネーム")) {
            categorySet.add(product["カテゴリーネーム"]!);
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
    // バックエンド側でカテゴリ絞り込み済みですが、念のためローカルでもフィルタリング
    List<Map<String, String>> filteredList = selectedCategory == "すべて"
        ? productList
        : productList.where((p) => p["カテゴリーネーム"] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("商品一覧"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  fetchProducts(); // カテゴリ変更時に再取得
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                var item = filteredList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(item["商品名"]!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("JANコード: ${item["JANコード"]}"),
                        Text("価格: ${item["価格"]}"),
                        Text("在庫数: ${item["在庫数"]}"),
                        Text("カテゴリ: ${item["カテゴリーネーム"]}"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(productData: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
