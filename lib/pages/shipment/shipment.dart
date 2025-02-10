import 'package:flutter/material.dart';

class ShipmentScreen extends StatefulWidget {
  @override
  _ShipmentScreenState createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> {
  List<Map<String, dynamic>> products = [
    {'id': 1, 'name': '商品A', 'price': 100, 'stock': 10, 'quantity': 0},
    {'id': 2, 'name': '商品B', 'price': 200, 'stock': 5, 'quantity': 0},
    {'id': 3, 'name': '商品C', 'price': 300, 'stock': 8, 'quantity': 0},
  ];

  List<Map<String, dynamic>> shipmentList = [];

  void addToShipment(Map<String, dynamic> product) {
    setState(() {
      var existing = shipmentList.firstWhere(
          (item) => item['id'] == product['id'],
          orElse: () => {});
      if (existing.isNotEmpty) {
        existing['quantity'] += product['quantity'];
      } else {
        shipmentList.add({'id': product['id'], 'name': product['name'], 'price': product['price'], 'quantity': product['quantity']});
      }
    });
  }

  void removeFromShipment(int id) {
    setState(() {
      shipmentList.removeWhere((item) => item['id'] == id);
    });
  }

  int calculateTotal() {
    return shipmentList.fold(0, (sum, item) => sum + ((item['price'] as num).toInt() * (item['quantity'] as num).toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('出庫（販売）画面')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('単価: ${product['price']}円 / 在庫: ${product['stock']}'),
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
                              if (product['quantity'] < product['stock']) {
                                product['quantity']++;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (product['quantity'] > 0) {
                      addToShipment(product);
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
                Text('出庫リスト', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: shipmentList.length,
                    itemBuilder: (context, index) {
                      var shipment = shipmentList[index];
                      return ListTile(
                        title: Text(shipment['name']),
                        subtitle: Text('数量: ${shipment['quantity']} 合計: ${shipment['price'] * shipment['quantity']}円'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => removeFromShipment(shipment['id']),
                        ),
                      );
                    },
                  ),
                ),
                Text('合計金額: ${calculateTotal()}円', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('出庫が確定しました')),
                    );
                    setState(() {
                      shipmentList.clear();
                    });
                  },
                  child: Text('出庫確定'),
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
