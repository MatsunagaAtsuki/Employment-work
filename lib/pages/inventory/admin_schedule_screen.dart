import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminScheduleScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  const AdminScheduleScreen({super.key, required this.productData});

  @override
  _AdminScheduleScreenState createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  // 追加: 新しい価格入力用コントローラー
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: (DateTime.now().minute ~/ 15) * 15),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // 24時間形式でフォーマット
        controller.text = picked.hour.toString().padLeft(2, '0') + ':' + picked.minute.toString().padLeft(2, '0');
      });
    }
  }

Future<void> _saveSchedule() async {
  String productId = widget.productData["商品ID"];
  String newPrice = _newPriceController.text;
  String startDate = _startDateController.text;
  String startTime = _startTimeController.text;
  String endDate = _endDateController.text;
  String endTime = _endTimeController.text;

  if (newPrice.isEmpty || startDate.isEmpty || startTime.isEmpty || endDate.isEmpty || endTime.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("すべての項目を入力してください。")),
    );
    return;
  }

  // 日付と時間を結合して DateTime オブジェクトを生成
  try {
    DateTime startDateTime = DateTime.parse("$startDate $startTime:00");
    DateTime endDateTime = DateTime.parse("$endDate $endTime:00");

    // 整合性チェック：開始日時が終了日時より前であること
    if (!startDateTime.isBefore(endDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("開始日時は終了日時より前でなければなりません。")),
      );
      return;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("日付または時間の形式が正しくありません。")),
    );
    return;
  }

  // バックエンドURLは実行環境に合わせて変更してください
  String url = 'http://127.0.0.1:5000/api/admin/schedule';
  Map<String, String> payload = {
    "productId": productId,
    "newPrice": newPrice,
    "startDate": startDate,
    "startTime": startTime,
    "endDate": endDate,
    "endTime": endTime,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("スケジュールが保存されました。")),
      );
      // 必要に応じて画面遷移や更新処理を追加
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("スケジュールの保存に失敗しました: ${response.body}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("エラーが発生しました。")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("スケジュール管理: ${widget.productData["商品名"]}")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品ID表示
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("商品ID:", textAlign: TextAlign.right, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Text(widget.productData["商品ID"], style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 追加: 新しい価格の入力欄
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("新しい価格:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _newPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "例: 150",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // スケジュール開始日
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("スケジュール開始日:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "YYYY-MM-DD",
                    ),
                    onTap: () => _selectDate(context, _startDateController),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 開始時間
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("開始時間:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _startTimeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "HH:mm",
                    ),
                    onTap: () => _selectTime(context, _startTimeController),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // スケジュール終了日
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("スケジュール終了日:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "YYYY-MM-DD",
                    ),
                    onTap: () => _selectDate(context, _endDateController),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 終了時間
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text("終了時間:", textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _endTimeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "HH:mm",
                    ),
                    onTap: () => _selectTime(context, _endTimeController),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: _saveSchedule,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text("スケジュールを保存", style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
