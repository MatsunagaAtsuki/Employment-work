import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Map<String, dynamic>> products = [
    {'id': 1, 'name': '商品A', 'price': 100, 'quantity': 0},
    {'id': 2, 'name': '商品B', 'price': 200, 'quantity': 0},
    {'id': 3, 'name': '商品C', 'price': 300, 'quantity': 0},
  ];

  List<Map<String, dynamic>> orderList = [];

  void addToOrder(Map<String, dynamic> product) {
    setState(() {
      var existing = orderList.firstWhere(
          (item) => item['id'] == product['id'],
          orElse: () => {});
      if (existing.isNotEmpty) {
        existing['quantity'] += product['quantity'];
      } else {
        orderList.add({'id': product['id'], 'name': product['name'], 'price': product['price'], 'quantity': product['quantity']});
      }
    });
  }

  void removeFromOrder(int id) {
    setState(() {
      orderList.removeWhere((item) => item['id'] == id);
    });
  }

int calculateTotal() {
  return orderList.fold(0, (sum, item) => sum + ((item['price'] as int) * (item['quantity'] as int)));
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('発注画面')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('単価: ${product['price']}円'),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (product['quantity'] > 0) {
                                product['quantity']--;
                              }
                            });
                          },
                        ),
                        Text('${product['quantity']}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              product['quantity']++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (product['quantity'] > 0) {
                      addToOrder(product);
                    }
                  },
                );
              },
            ),
          ),
          Divider(),
          Expanded(
            child: Column(
              children: [
                Text('発注リスト', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      var order = orderList[index];
                      return ListTile(
                        title: Text(order['name']),
                        subtitle: Text('数量: ${order['quantity']} 合計: ${order['price'] * order['quantity']}円'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeFromOrder(order['id']),
                        ),
                      );
                    },
                  ),
                ),
                Text('合計金額: ${calculateTotal()}円', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // 仮の発注確定処理
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('発注が確定しました')),
                    );
                    setState(() {
                      orderList.clear();
                    });
                  },
                  child: Text('発注確定'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
