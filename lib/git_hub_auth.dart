import 'dart:convert';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

const clientId = "";  // GitHub Developer Settingsから取得
const clientSecret = "";// GitHub Developer Settingsから取得
const redirectUri = "gmemo://oauth-callback";

Future<String?> loginWithGitHub() async{
  //  ユーザーがログイン
  final authUrl = Uri.https("github.com","/login/oauth/authorize",{
    "client_id" : clientId,
    "redirect_uri" : redirectUri,
    "scope": "repo"
  });

  final result = await FlutterWebAuth2.authenticate(
    url: authUrl.toString(),
    callbackUrlScheme: "gmemo",
  );

  //  一時的なアクセスコードを取得
  final code = Uri.parse(result).queryParameters["code"];

  if(code == null) return null;

  //  アクセスコードを使ってアクセストークンを取得
  //  アクセストークンを使わないとAPIの操作はできない
  final response = await http.post(Uri.https("github.com","/login/oauth/access_token"),headers: {"Accept": "application/json"},body: {
    "client_id" : clientId,
    "client_secret" : clientSecret,
    "code" : code,
    "redirect_uri" : redirectUri,
  });

  //  取得したアクセストークンを返す
  final accessToken = jsonDecode(response.body)["access_token"];
  return accessToken;
}