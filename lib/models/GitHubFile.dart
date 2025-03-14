// ファイル情報を扱うためのクラス
class GitHubFile {
  final String name; // ファイル名
  final String path; // パス
  final String type; // タイプ（file or dir）
  final String? downloadUrl; // ファイルの場合のみ存在

  GitHubFile({
    required this.name,
    required this.path,
    required this.type,
    this.downloadUrl,
  });

  factory GitHubFile.fromJson(Map<String, dynamic> json) {
    return GitHubFile(
      name: json['name'],
      path: json['path'],
      type: json['type'], // "file" または "dir"
      downloadUrl: json['download_url'],
    );
  }
}
