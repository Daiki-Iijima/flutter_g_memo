import 'package:flutter/material.dart';

class RepositoryListScreen extends StatefulWidget {
  final List<String> repoList;
  final void Function() onLogout;

  const RepositoryListScreen({
    super.key,
    required this.repoList,
    required this.onLogout,
  });

  @override
  State<RepositoryListScreen> createState() => _RepositoryListScreenState();
}

class _RepositoryListScreenState extends State<RepositoryListScreen> {
  List<String> showRepoList = [];

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
                (name) => name.contains(value),
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
                  child: ListTile(title: Text(showRepoList[i]), onTap: () {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
