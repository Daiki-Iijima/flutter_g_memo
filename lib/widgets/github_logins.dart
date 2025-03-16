import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../git_hub_auth.dart';

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

  void _launchPrivacyPolicyURL() async {
    final Uri url = Uri.parse(
      'https://obtainable-join-42d.notion.site/GMemo-Privacy-Policy-1b7d3fb892128027a84dd5df9ffea0af?pvs=4',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          ElevatedButton(onPressed: _login, child: Text("GitHub ログイン")),
          const Spacer(),
          TextButton(
            onPressed: _launchPrivacyPolicyURL,
            child: Text("Privacy Policy"),
          ),
        ],
      ),
    );
  }
}
