import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github_repos/models/repo.dart';
import 'package:github_repos/models/repo_model.dart';
import 'package:github_repos/network/model_response.dart';
import 'package:github_repos/network/repos_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _buildReposLoader(context),
        ),
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
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: repo.owner.avatarURL,
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repo.fullName,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Palatino',
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          repo.description,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[400],
                            fontFamily: 'Palatino',
                          ),
                        ),
                        Wrap(
                          children: _buildRepoTopics(repo.topics),
                        ),
                        const SizedBox(
                          height: 28.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/ic_fork.svg',
                                  height: 15,
                                  width: 15,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  repo.forks.toString(),
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Palatino',
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  'assets/ic_star.svg',
                                  height: 14,
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  repo.star.toString(),
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Palatino',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRepoTopics(List<String>? topics) {
    List<Widget> topicWidgets = [const Text("")];
    if (topics == null) return topicWidgets;
    for (final topic in topics) {
      topicWidgets.add(Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.09),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          child: Text("#" + topic)));
    }
    return topicWidgets;
  }
}
