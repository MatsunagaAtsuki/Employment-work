import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/dashboard/dashboard_screen.dart';
import 'package:inventory_manager/pages/product/edit_product_screen.dart';

class AdminLoginPage extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  
  const AdminLoginPage({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("管理者ログイン"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 仮の認証チェック
                  if (usernameController.text == "" && passwordController.text == "") {
                    Navigator.pop(context);
                    onLoginSuccess();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ログイン失敗。ユーザー名またはパスワードが違います")),
                    );
                  }
                },
                child: const Text("ログイン"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
