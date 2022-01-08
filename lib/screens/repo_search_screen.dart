import 'dart:collection';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_repos/models/repo.dart';
import 'package:github_repos/models/repo_model.dart';
import 'package:github_repos/network/model_response.dart';
import 'package:github_repos/network/repos_service.dart';
import 'package:github_repos/screens/repo_detail_screen.dart';

class RepoSearchScreen extends StatefulWidget {
  const RepoSearchScreen({Key? key}) : super(key: key);

  @override
  _RepoSearchScreenState createState() => _RepoSearchScreenState();
}

class _RepoSearchScreenState extends State<RepoSearchScreen> {
  bool loading = false;
  List<Repo> currentSearchList = [];
  bool isErrorState = false;
  int currentCount = 0;

  APIRepoQuery? _repoQuery = null;

  Future loadRecipes() async {
    await ReposService.create().queryRepos('flutter');
    // final jsonString = await rootBundle.loadString('assets/recipes1.json');
    // setState(() {
    //   // 2
    //   _repoQuery = APIRepoQuery.fromJson(jsonDecode(jsonString));
    //   print(_repoQuery?.reposCount);
    // });
  }

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildReposLoader(context),
        // ListView.builder(
        //     itemCount: 0,
        //     itemBuilder: (BuildContext context, int index) {
        //       return GestureDetector(
        //           onTap: () {
        //             Navigator.push(context,
        //                 MaterialPageRoute(builder: (context) {
        //               return RepoDetailScreen(repo: Repo.repos[index]);
        //             }));
        //           },
        //           child: buildRepoCard(Repo.repos[index]));
        //     })
      ),
    );
  }

  Widget _buildReposLoader(BuildContext context) {
    return FutureBuilder<Response<Result<APIRepoQuery>>>(
        future: ReposService.create().queryRepos("flutter"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.3,
                ),
              );
            }

            loading = false;

            if (false == snapshot.data?.isSuccessful) {
              var errorMessage = "Problems getting data";
              if (snapshot.data?.error != null &&
                  snapshot.data?.error is LinkedHashMap) {
                final map = snapshot.data?.error as LinkedHashMap;
                errorMessage = map['message'];
              }
              return Center(
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0),
                ),
              );
            }

            final result = snapshot.data?.body;
            if (result == null || result is Error) {
              isErrorState = true;
              return _buildReposList(context, currentSearchList);
            }
            final query = (result as Success).value;
            isErrorState = false;
            currentSearchList.addAll(query.repos);

            return _buildReposList(context, currentSearchList);
          }
          return _buildReposList(context, currentSearchList);
        });
  }

  Widget _buildReposList(BuildContext reposListContext, List<Repo> repos) {
    return ListView.builder(
        itemCount: repos.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildRepoCard(reposListContext, repos, index);
        });
  }

  Widget _buildRepoCard(
      BuildContext topLevelContext, List<Repo> repos, int index) {
    final repo = repos[index];
    return GestureDetector(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                repo.fullName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Palatino',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
