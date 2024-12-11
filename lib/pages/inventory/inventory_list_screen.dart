import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("在庫リスト"),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
      //child: TableView.builder(
        
      //),
      ),
    );
  }
}
