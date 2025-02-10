import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    List<Map<String, dynamic>> data = [
      {"商品ID": "1001", "商品名": "スマートフォン", "カテゴリー": "電子機器", "価格": 50000},
      {"商品ID": "1002", "商品名": "ノートPC", "カテゴリー": "PC・周辺機器", "価格": 120000},
      {"商品ID": "1003", "商品名": "ワイヤレスイヤホン", "カテゴリー": "オーディオ", "価格": 9800},
      {"商品ID": "1004", "商品名": "スマートウォッチ", "カテゴリー": "電子機器", "価格": 25000},
    ];

    setState(() {
      productList = data;
      categories.addAll(data.map((e) => e["カテゴリー"] as String).toSet());
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = productList.where((product) {
      return (selectedCategory == "すべて" || product["カテゴリー"] == selectedCategory) &&
          (product["商品名"].contains(_searchController.text) ||
           product["商品ID"].contains(_searchController.text));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("出庫画面")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "商品検索",
                border: OutlineInputBorder(),
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
                                if (shipmentQuantities[item["商品ID"]] != null && shipmentQuantities[item["商品ID"]]! > 0) {
                                  shipmentQuantities[item["商品ID"]] = shipmentQuantities[item["商品ID"]]! - 1;
                                }
                              });
                            },
                          ),
                          Text(shipmentQuantities[item["商品ID"]]?.toString() ?? "0"),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                shipmentQuantities[item["商品ID"]] = (shipmentQuantities[item["商品ID"]] ?? 0) + 1;
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
                _showShipmentSummaryDialog();
              },
              child: const Text("出庫確定"),
            ),
          ],
        ),
      ),
    );
  }

  void _showShipmentSummaryDialog() {
    List<Map<String, dynamic>> shippedItems = productList.where((item) => shipmentQuantities[item["商品ID"]] != null && shipmentQuantities[item["商品ID"]]! > 0).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("出庫確認"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: shippedItems.map((item) {
            int quantity = shipmentQuantities[item["商品ID"]]!;
            int totalPrice = quantity * (item["価格"] as num).toInt();
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
              setState(() {
                shipmentQuantities.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("出庫が確定しました")),
              );
            },
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }
}
