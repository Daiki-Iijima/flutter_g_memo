class GithubRepo {
  final String owner;
  final String name;
  final String contentsUrl;
  final bool isPrivate;

  GithubRepo({
    required this.owner,
    required this.name,
    required this.contentsUrl,
    required this.isPrivate,
  });
}
