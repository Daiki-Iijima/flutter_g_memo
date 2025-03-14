import 'package:flutter/material.dart';
import 'package:g_memo/models/GitHubRepo.dart';

class RepositoryListScreen extends StatefulWidget {
  final List<GithubRepo> repoList;
  final void Function(GithubRepo) onSelectedRepository;

  const RepositoryListScreen({
    super.key,
    required this.repoList,
    required this.onSelectedRepository,
  });

  @override
  State<RepositoryListScreen> createState() => _RepositoryListScreenState();
}

class _RepositoryListScreenState extends State<RepositoryListScreen> {
  List<GithubRepo> showRepoList = [];

  @override
  void initState() {
    super.initState();
    showRepoList.addAll(widget.repoList);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              if (value.isEmpty) {
                showRepoList.clear();
                setState(() {
                  showRepoList.addAll(widget.repoList);
                });
                return;
              }

              final resultList = widget.repoList.where(
                (repo) => repo.name.contains(value),
              );
              showRepoList.clear();
              setState(() {
                showRepoList.addAll(resultList);
              });
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: showRepoList.length,
              itemBuilder: (ctx, i) {
                return Card(
                  child: ListTile(
                    title: Text(showRepoList[i].name),
                    onTap: () {
                      widget.onSelectedRepository(showRepoList[i]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
