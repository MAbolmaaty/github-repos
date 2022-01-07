import 'package:flutter/material.dart';
import 'package:github_repos/models/repo.dart';

class RepoDetailScreen extends StatefulWidget {
  final Repo repo;

  const RepoDetailScreen({Key? key, required this.repo}) : super(key: key);

  @override
  _RepoDetailScreenState createState() => _RepoDetailScreenState();
}

class _RepoDetailScreenState extends State<RepoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.repo.fullName),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Text(
            widget.repo.fullName,
            style: const TextStyle(fontSize: 18),
          )
        ],
      )),
    );
  }
}
