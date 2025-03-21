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
  final _searchFieldController = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchFieldController,
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
              decoration: InputDecoration(
                label: Text("リポジトリ名"),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchFieldController.clear();
                    showRepoList.clear();
                    setState(() {
                      showRepoList.addAll(widget.repoList);
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
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
