import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productPrice;
  const ScheduleScreen(
      {super.key,
      required this.productId,
      required this.productName,
      required this.productPrice});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  double? currentPrice = 50000.00; // 仮の現在価格（バックエンドと接続時に取得）
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _setDefaultDateTime();
  }

  void _setDefaultDateTime() {
    DateTime now = DateTime.now();
    _startDateController.text = DateFormat('yyyy-MM-dd').format(now);
    selectedTime = _getNearestTime(now);
    _startTimeController.text = selectedTime ?? '';
  }

  String _getNearestTime(DateTime now) {
    int minute = (now.minute ~/ 15 + 1) * 15;
    int hour = now.hour;
    if (minute >= 60) {
      minute = 0;
      hour = (hour + 1) % 24;
    }
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("売価スケジュール作成")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FixedColumnWidth(120),
                1: FlexColumnWidth(),
              },
              children: [
                _buildTableRow("商品名", widget.productName),
                _buildTableRow("商品ID", widget.productId),
                _buildTableRow(
                    "現在の価格(￥)",widget.productPrice),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "新しい価格",
                prefixText: "¥",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _startDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "開始日",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "開始時間",
                border: OutlineInputBorder(),
              ),
              value: selectedTime,
              items: _generateTimeOptions(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTime = newValue;
                  _startTimeController.text = newValue ?? '';
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: "終了日 (YYYY-MM-DD, 任意)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showConfirmationDialog,
                child: const Text("スケジュールを確定"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 修正済み：重複を排除してソートした時間リストを生成
  List<DropdownMenuItem<String>> _generateTimeOptions() {
    Set<String> timeSet = {};
    DateTime now = DateTime.now();
    String nearestTime = _getNearestTime(now);
    bool reachedCurrentTime = false;
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        String time =
            "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
        if (!reachedCurrentTime && time == nearestTime) {
          reachedCurrentTime = true;
        }
        if (reachedCurrentTime) {
          timeSet.add(time);
        }
      }
    }
    List<String> times = timeSet.toList()..sort((a, b) => a.compareTo(b));
    if (selectedTime == null || !times.contains(selectedTime)) {
      selectedTime = times.isNotEmpty ? times.first : null;
      _startTimeController.text = selectedTime ?? '';
    }
    return times
        .map((time) => DropdownMenuItem(value: time, child: Text(time)))
        .toList();
  }

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value.toString(), style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    String newPrice = _newPriceController.text;
    String startDate = _startDateController.text;
    String startTime = _startTimeController.text;
    String endDate = _endDateController.text;
    if (newPrice.isEmpty || startDate.isEmpty || startTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("新しい価格、開始日、開始時間を入力してください")),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("売価スケジュールの確認"),
        content: Text("商品名: ${widget.productName}\n"
            "現在の価格: ¥${currentPrice?.toStringAsFixed(2)}\n"
            "新しい価格: ¥$newPrice\n"
            "開始日: $startDate $startTime\n"
            "終了日: ${endDate.isNotEmpty ? endDate : 'なし'}\n\n"
            "スケジュールを確定しますか？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("キャンセル"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applySchedule(newPrice, startDate, startTime, endDate);
            },
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }

  void _applySchedule(String newPrice, String startDate, String startTime,
      String endDate) async {
    final url = 'http://127.0.0.1:5000/api/schedule';
    //final url = 'http://10.0.2.2:5000/api/schedule';
    final payload = {
      "productId": widget.productId,
      "newPrice": newPrice,
      "startDate": startDate,
      "startTime": startTime,
      "endDate": endDate,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("売価スケジュールを設定しました")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("エラーが発生しました: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("エラーが発生しました")),
      );
    }
  }
}
