import 'package:flutter/material.dart';
import "package:flutter_jissenn_08/data.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

// 入力状態のウィジェットを実装する
class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {

  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* ◆ Padding 余白を与えて子要素を配置するWidget */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _textEditingController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '文章を入力してください',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '文章が入力されていません';
                }
                return null;
              },
            ),
          ),
          /* ◆ SizedBox サイズを指定できるWidget */
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final formState = _formKey.currentState;
              if (formState == null || !formState.validate()) {
                return;
              }

              final url = Uri.parse('https://labs.goo.ne.jp/api/hiragana');
              final headers = {'Content-Type': 'application/json'};

              final request = Request(
                appId: const String.fromEnvironment('appId'),
                sentence: _textEditingController.text,
              );

              try {
                final result = await http.post(
                  url,
                  headers: headers,
                  body: jsonEncode(request.toJson()),
                );

                if (result.statusCode == 200) {
                  final response = Response.fromJson(
                    jsonDecode(result.body) as Map<String, dynamic>,
                  );
                  debugPrint('変換結果: ${response.converted}');
                } else {
                  // エラーハンドリング
                  debugPrint('APIリクエストエラー: ${result.statusCode}');
                }
              } catch (e) {
                // エラーハンドリング
                debugPrint('APIリクエストエラー: $e');
              }
            },
            child: const Text(
              '変換',
            ),
          ),
        ],
      )
    );
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}