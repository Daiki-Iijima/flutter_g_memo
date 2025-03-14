import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GitHubFile {
  final String owner;
  final String repo;
  final String token;

  final String name;
  final String path;
  final String type;
  final String? downloadUrl;
  final String? sha;
  final int? size;

  File? _localFile; // 変更可能にする

  GitHubFile({
    required this.owner,
    required this.repo,
    required this.token,
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
    this.sha,
    this.size,
  });

  // localFile の getter/setter
  File? get localFile => _localFile;

  set localFile(File? file) {
    _localFile = file;
  }

  factory GitHubFile.fromJson({
    required String owner,
    required String repo,
    required String token,
    required Map<String, dynamic> json,
  }) {
    return GitHubFile(
      owner: owner,
      repo: repo,
      token: token,
      name: json['name'],
      path: json['path'],
      type: json['type'],
      downloadUrl: json['download_url'],
      sha: json['sha'],
      size: json['size'],
    );
  }

  // 📌 ファイルかどうか判定
  bool get isFile => type == "file";

  // 📌 ディレクトリかどうか判定
  bool get isDirectory => type == "dir";

  // 📌 ファイルの拡張子を取得
  String get fileExtension {
    if (!isFile || !name.contains('.')) return '';
    return name.split('.').last.toLowerCase();
  }

  // 📌 GitHubからSHAを取得（必要な場合のみ）
  Future<String?> fetchSha() async {
    if (sha != null) return sha;

    final response = await http.get(
      Uri.parse('https://api.github.com/repos/$owner/$repo/contents/$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['sha'];
    } else {
      print('SHA取得失敗: ${response.statusCode}');
      return null;
    }
  }

  // 📌 GitHubへアップロード（更新）
  Future<bool> upload() async {
    if (!isFile || localFile == null) {
      print('アップロードできるファイルがありません');
      return false;
    }

    try {
      // SHAを取得（キャッシュがなければAPIから取得）
      final fileSha = await fetchSha();

      // ローカルファイルをBase64エンコード
      final fileBytes = await localFile!.readAsBytes();
      final encodedContent = base64Encode(fileBytes);

      // 更新リクエスト
      final response = await http.put(
        Uri.parse('https://api.github.com/repos/$owner/$repo/contents/$path'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/vnd.github.v3+json',
        },
        body: jsonEncode({
          'message': 'Flutterアプリから更新',
          'content': encodedContent,
          'sha': fileSha,
        }),
      );

      if (response.statusCode == 200) {
        print('アップロード成功: $path');
        return true;
      } else {
        print('アップロード失敗: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('アップロードエラー: $e');
      return false;
    }
  }

  @override
  String toString() {
    return 'GitHubFile(owner: $owner, repo: $repo, name: $name, path: $path, type: $type, sha: $sha, size: $size)';
  }
}
