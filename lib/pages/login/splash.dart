import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<SplashPage> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer(
      const Duration(seconds: 5),//遅延時間
          () {
            // ここに遷移メソッド
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }
//リソースの開放
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 300,
              width: 600,
              color: const Color.fromARGB(255, 124, 197, 234),
              child: const Text("ようこそ"),
            ),
          ],
        ),
      ),
    );
  }
}
