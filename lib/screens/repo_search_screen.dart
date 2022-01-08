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
  late TextEditingController searchTextController;
  bool gridView = false;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController(text: 'flutter');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildReposLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.4),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  startSearch();
                },
                icon: const Icon(Icons.search)),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Search'),
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  controller: searchTextController,
                  onEditingComplete: () {
                    startSearch();
                  },
                ))
              ],
            )),
            GestureDetector(
              onTap: () {
                setState(() {
                  gridView = !gridView;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  gridView ? 'assets/ic_list.svg' : 'assets/ic_grid.svg',
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      currentSearchList.clear();
    });
  }

  Widget _buildReposLoader(BuildContext context) {
    if (searchTextController.text.length < 2) {
      return Container();
    }
    return FutureBuilder<Response<Result<APIRepoQuery>>>(
        future:
            ReposService.create().queryRepos(searchTextController.text.trim()),
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
              return _buildRepos(context, currentSearchList);
            }
            final query = (result as Success).value;
            isErrorState = false;
            currentSearchList.addAll(query.repos);

            return _buildRepos(context, currentSearchList);
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget _buildRepos(BuildContext reposListContext, List<Repo> repos) {
    final size = MediaQuery.of(context).size;
    final itemHeight = 350;
    final itemWidth = size.width / 2;
    return Flexible(
      child: gridView
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight)),
              itemCount: repos.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRepoCardForGrid(reposListContext, repos, index);
              })
          : ListView.builder(
              itemCount: repos.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRepoCardForList(reposListContext, repos, index);
              }),
    );
  }

  Widget _buildRepoCardForList(
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
                        const SizedBox(
                          height: 10,
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
                                  'assets/ic_screwdriver.svg',
                                  height: 14,
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  repo.programmingLanguage,
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

  Widget _buildRepoCardForGrid(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                height: 12.0,
              ),
              Text(
                repo.fullName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[400],
                  fontFamily: 'Palatino',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                children: _buildRepoTopics(repo.topics),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
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
                ),
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
    for (int i = 0; i < topics.length; i++) {
      if (gridView && i == 3) break;
      topicWidgets.add(Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.09),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          child: Text("#" + topics[i])));
    }
    return topicWidgets;
  }
}
