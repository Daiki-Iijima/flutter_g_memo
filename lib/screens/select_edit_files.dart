import 'package:flutter/material.dart';
import 'package:g_memo/models/GitHubFile.dart';

class SelectEditFileScreen extends StatelessWidget {
  final List<GitHubFile> contents;

  const SelectEditFileScreen({super.key, required this.contents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("編集ファイル選択")),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              if (value.isEmpty) {
                return;
              }
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: contents.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: ListTile(title: Text(contents[i].name), onTap: () {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
