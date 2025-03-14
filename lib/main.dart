import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g_memo/git_hub_auth.dart';
import 'package:g_memo/github_logins.dart';
import 'package:g_memo/repository_lists.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const GMemoApp());
}

class GMemoApp extends StatelessWidget {
  const GMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'GitHub Memo', home: EntryScreen());
  }
}

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  String? _accessToken;
  final _storage = const FlutterSecureStorage();
  static const _githubTokenKey = "github_token";
  var _loadingRepos = false;

  final List<String> _repos = [];

  Future<void> _loadAccessToken() async {
    final token = await _storage.read(key: _githubTokenKey);

    if (token == null) {
      //  ログイン画面に遷移
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) {
            return GithubLoginsScreen(onGetAccessToken: _getAccessTokenHandler);
          },
        ),
      );
      return;
    }

    //  リポジトリの一覧を取得
    _getRepositories(token);

    //  アクセストークンを読み込み
    setState(() {
      _accessToken = token;
    });
  }

  void _logout() {
    _storage.delete(key: _githubTokenKey);
    //  キーを削除
    setState(() {
      _accessToken = null;
    });
  }

  void _getRepositories(String token) async {
    setState(() {
      _loadingRepos = true;
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
        _repos.add(repo["name"].toString());
      }
    } else {
      print("リポジトリ一覧の取得に失敗");
    }

    setState(() {
      _loadingRepos = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //  以前ログインしていれば読み込まれる
    _loadAccessToken();
  }

  void _getAccessTokenHandler(String accessToken) async {
    //  アクセストークンをSecureStorageに保存
    await _storage.write(key: _githubTokenKey, value: accessToken);

    setState(() {
      _accessToken = accessToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = "G Memo";
    Widget mainContent = Center(child: Text("リポジトリ一覧を取得中..."));

    //  ログイン画面
    if (_accessToken == null) {
      title = "ログイン";
      mainContent = GithubLoginsScreen(
        onGetAccessToken: _getAccessTokenHandler,
      );
    }

    if (_accessToken != null && !_loadingRepos) {
      title = "リポジトリ選択";
      mainContent = RepositoryListScreen(repoList: _repos, onLogout: _logout);
    }

    return Scaffold(appBar: AppBar(title: Text(title)), body: mainContent);
  }
}
