import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70, // 高さを調整
            backgroundColor: const Color.fromARGB(255, 243, 244, 245),
            shape: const Border(
                bottom: BorderSide(color: Colors.black, width: 1.2)),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ここになんかいれる",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextButton(onPressed: null, child: Text("ポータル")),
                    ),
                    SizedBox(
                      //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child:
                          TextButton(onPressed: null, child: Text("ダッシュボード")),
                    ),
                    SizedBox(
                      // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextButton(onPressed: null, child: Text("在庫一覧")),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: const Center(
            child: Text("ss"),
          )),
    );
  }
}
