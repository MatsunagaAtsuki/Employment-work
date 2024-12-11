import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70, // 高さを調整
      backgroundColor: const Color.fromARGB(255, 243, 244, 245),
      shape: const Border(
          bottom: BorderSide(color: Colors.black, width: 1.2)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          Row(
            children: [
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    // ボタンの動作を実装
                    print("ポータルがクリックされました");
                  },
                  child: const Text("ポータル"),
                ),
              ),
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    // ボタンの動作を実装
                    print("ダッシュボードがクリックされました");
                  },
                  child: const Text("ダッシュボード"),
                ),
              ),
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    // ボタンの動作を実装
                    print("在庫一覧がクリックされました");
                  },
                  child: const Text("在庫一覧"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
