import 'package:flutter/material.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<Map<String, String>> productList = [];

  @override
  void initState() {
    super.initState();
    _loadMockData(); // 仮データをロード
  }

  void _loadMockData() {
    setState(() {
      productList = [
        {
          "商品名": "スマートフォン",
          "JANコード": "4901234567890",
          "価格": "¥50,000",
          "在庫数": "15",
          "カテゴリーID": "1",
          "カテゴリーネーム": "電子機器"
        },
        {
          "商品名": "ノートPC",
          "JANコード": "4909876543210",
          "価格": "¥120,000",
          "在庫数": "8",
          "カテゴリーID": "2",
          "カテゴリーネーム": "PC・周辺機器"
        },
        {
          "商品名": "ワイヤレスイヤホン",
          "JANコード": "4905678123456",
          "価格": "¥9,800",
          "在庫数": "30",
          "カテゴリーID": "3",
          "カテゴリーネーム": "オーディオ"
        },
        {
          "商品名": "スマートウォッチ",
          "JANコード": "4906789543210",
          "価格": "¥25,000",
          "在庫数": "12",
          "カテゴリーID": "1",
          "カテゴリーネーム": "電子機器"
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("商品一覧")),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          var item = productList[index];
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
                // 商品詳細ページに遷移する処理（後で追加）
              },
            ),
          );
        },
      ),
    );
  }
}
