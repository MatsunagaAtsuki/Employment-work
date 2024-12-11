import 'package:flutter/material.dart';
import 'package:inventory_manager/pages/dashboard/dashboard_screen.dart';
//import '../../utils/waitable_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("login"),
      //   backgroundColor: Colors.blue,
      // ),
      body: Center(
        child: Container(
          // color: Color.fromARGB(255, 198, 26, 26),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "username"),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "password"),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardScreen()));
                    },
                    child: const Text("ログイン")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
