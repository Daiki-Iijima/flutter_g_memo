import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_memo/models/GitHubFile.dart';
import 'package:g_memo/screens/edit_files.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SelectEditFileScreen extends StatefulWidget {
  final List<GitHubFile> contents;

  const SelectEditFileScreen({super.key, required this.contents});

  @override
  State<SelectEditFileScreen> createState() => _SelectEditFileScreenState();
}

class _SelectEditFileScreenState extends State<SelectEditFileScreen> {
  List<GitHubFile> showContentList = [];

  @override
  void initState() {
    super.initState();
    showContentList.addAll(widget.contents);
  }

  Future<String?> _fetchLatestDownloadUrl(
    String owner,
    String repo,
    String path,
    String token,
  ) async {
    final url = "https://api.github.com/repos/$owner/$repo/contents/$path";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/vnd.github.v3+json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData["download_url"];
    } else {
      if (kDebugMode) {
        print("最新の download_url 取得失敗: ${response.statusCode}");
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("編集ファイル選択")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                if (value.isEmpty) {
                  showContentList.clear();
                  setState(() {
                    showContentList.addAll(widget.contents);
                  });
                  return;
                }

                final resultList = widget.contents.where(
                  (repo) => repo.name.contains(value),
                );
                showContentList.clear();
                setState(() {
                  showContentList.addAll(resultList);
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: showContentList.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: ListTile(
                    title: Text(showContentList[i].name),
                    onTap: () async {
                      print("最新の `download_url` を取得中...");

                      final latestDownloadUrl = await _fetchLatestDownloadUrl(
                        showContentList[i].owner,
                        showContentList[i].repo,
                        showContentList[i].path,
                        showContentList[i].token,
                      );

                      if (latestDownloadUrl == null) {
                        print("最新の `download_url` 取得に失敗");
                        return;
                      }

                      print("最新の `download_url`: $latestDownloadUrl");

                      final response = await http.get(
                        Uri.parse(latestDownloadUrl),
                      );

                      if (response.statusCode != 200) {
                        print("ダウンロード失敗: ${response.statusCode}");
                        return;
                      }

                      final directory =
                          await getApplicationDocumentsDirectory();
                      final filePath =
                          "${directory.path}/${showContentList[i].name}";
                      final file = File(filePath);

                      // 既存ファイル削除
                      if (await file.exists()) {
                        await file.delete();
                        print("既存ファイルを削除: $filePath");
                      }

                      // 新しく保存
                      await file.writeAsBytes(response.bodyBytes);
                      print("ダウンロード成功: $filePath");

                      showContentList[i].localFile = file;
                      //  編集画面に遷移
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return EditFileScreen(
                              file: showContentList[i],
                              onSave: (file) async {
                                final result = await file.upload();

                                //  結果を表示
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result ? "保存完了" : "保存失敗"),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
