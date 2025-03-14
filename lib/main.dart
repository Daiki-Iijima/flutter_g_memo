import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g_memo/git_hub_auth.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GMemoApp());
}

class GMemoApp extends StatelessWidget {
  const GMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'GitHub Memo', home: GitHubLoginScreen());
  }
}

class GitHubLoginScreen extends StatefulWidget {
  const GitHubLoginScreen({super.key});

  @override
  State<GitHubLoginScreen> createState() => _GitHubLoginScreenState();
}

class _GitHubLoginScreenState extends State<GitHubLoginScreen> {
  String? _accessToken;
  final _storage = const FlutterSecureStorage();
  static const _githubTokenKey = "github_token";

  Future<void> _loadAccessToken() async {
    final token = await _storage.read(key: _githubTokenKey);
    //  アクセストークンを読み込み
    setState(() {
      _accessToken = token;
    });

    //  試しにリポジトリの一覧を取得
    final response = await http.get(
      Uri.parse("https://api.github.com/user/repos"),
      headers: {
        "Authorization": "token $token",
        "Accept": "application/vnd.github.v3+json",
      },
    );

    if (response.statusCode == 200) {
      final repos = List<Map<String, dynamic>>.from(json.decode(response.body));
      for (final repo in repos) {
        for (final key in repo.keys) {
          print(key);
        }
      }
    } else {
      print("リポジトリ一覧の取得に失敗");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAccessToken();
  }

  Future<void> _login() async {
    final token = await loginWithGitHub();
    setState(() {
      _accessToken = token;
    });

    //  アクセストークンをSecureStorageに保存
    await _storage.write(key: _githubTokenKey, value: token);
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = ElevatedButton(
      onPressed: _login,
      child: Text("GitHub ログイン"),
    );

    //  トークンがすでにあるので、リポジトリリストを取得する
    if (_accessToken != null) {
      mainContent = ListView.builder(
        itemCount: 0,
        itemBuilder: (ctx, index) {},
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("GitHub Memo")),
      body: Center(child: mainContent),
    );
  }
}
