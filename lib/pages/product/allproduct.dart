import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/product/product_detail.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<Map<String, String>> productList = [];
  String selectedCategory = "すべて";
  List<String> categories = ["すべて"];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    List<Map<String, String>> data = [
      {
        "商品ID": "1001",
        "商品名": "スマートフォン",
        "JANコード": "4901234567890",
        "価格": "¥50,000",
        "在庫数": "15",
        "カテゴリーID": "1",
        "カテゴリーネーム": "電子機器"
      },
      {
        "商品ID": "1002",
        "商品名": "ノートPC",
        "JANコード": "4909876543210",
        "価格": "¥120,000",
        "在庫数": "8",
        "カテゴリーID": "2",
        "カテゴリーネーム": "PC・周辺機器"
      },
      {
        "商品ID": "1003",
        "商品名": "ワイヤレスイヤホン",
        "JANコード": "4905678123456",
        "価格": "¥9,800",
        "在庫数": "30",
        "カテゴリーID": "3",
        "カテゴリーネーム": "オーディオ"
      },
      {
        "商品ID": "1004",
        "商品名": "スマートウォッチ",
        "JANコード": "4906789543210",
        "価格": "¥25,000",
        "在庫数": "12",
        "カテゴリーID": "1",
        "カテゴリーネーム": "電子機器"
      },
    ];
    
    setState(() {
      productList = data;
      categories.addAll(data.map((e) => e["カテゴリーネーム"]!).toSet());
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
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
