import 'package:flutter/material.dart';
import 'package:g_memo/models/GitHubFile.dart';

import '../admob/ad_banner_widget.dart';

class EditFileScreen extends StatefulWidget {
  final GitHubFile file;
  final Function(GitHubFile) onSave;

  const EditFileScreen({super.key, required this.file, required this.onSave});

  @override
  State<EditFileScreen> createState() => _EditFileScreenState();
}

class _EditFileScreenState extends State<EditFileScreen> {
  String currentContentStr = "";

  final TextEditingController _controller = TextEditingController();

  void _readFile() async {
    currentContentStr = await widget.file.localFile!.readAsString();

    setState(() {
      _controller.text = currentContentStr;
    });
  }

  @override
  void initState() {
    super.initState();

    _readFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("メモ"),
        actions: [
          IconButton(
            onPressed: () {
              widget.onSave(widget.file);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TextFormField(
          controller: _controller,
          maxLines: null, // 複数行に対応
          expands: true, // 画面いっぱいに広げる
          onChanged: (value) {
            setState(() {
              _controller.text = value;
            });
            widget.file.localFile!.writeAsString(value);
          },
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(), // 広告表示
    );
  }
}
