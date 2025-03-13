import 'package:flutter/material.dart';
import 'package:g_memo/git_hub_auth.dart';

void main() {
  runApp(const GMemoApp());
}

class GMemoApp extends StatelessWidget {
  const GMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Memo',
      home: GitHubLoginScreen()
    );
  }
}

class GitHubLoginScreen extends StatefulWidget {
  const GitHubLoginScreen({super.key});

  @override
  State<GitHubLoginScreen> createState() => _GitHubLoginScreenState();
}

class _GitHubLoginScreenState extends State<GitHubLoginScreen> {

  String? _accessToken;

  Future<void> _login() async{
    final token = await loginWithGitHub();
    setState(() {
      _accessToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget mainContent = ElevatedButton(onPressed: _login, child: Text("GitHub ログイン"));

    if(_accessToken != null){
      mainContent = Text(_accessToken!);
    }

    return Scaffold(
      appBar: AppBar(title: Text("GitHub Memo")),
      body: Center(child: mainContent,),
    );
  }
}


