import 'package:flutter/material.dart';

import 'git_hub_auth.dart';

class GithubLoginsScreen extends StatelessWidget {
  final void Function(String) onGetAccessToken;

  const GithubLoginsScreen({super.key, required this.onGetAccessToken});

  Future<void> _login() async {
    final token = await loginWithGitHub();

    if (token == null) {
      return;
    }

    onGetAccessToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(onPressed: _login, child: Text("GitHub ログイン")),
    );
  }
}
