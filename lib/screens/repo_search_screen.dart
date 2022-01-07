import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_repos/models/repo.dart';
import 'package:github_repos/models/repo_model.dart';
import 'package:github_repos/network/repos_service.dart';
import 'package:github_repos/screens/repo_detail_screen.dart';

class RepoSearchScreen extends StatefulWidget {
  const RepoSearchScreen({Key? key}) : super(key: key);

  @override
  _RepoSearchScreenState createState() => _RepoSearchScreenState();
}

class _RepoSearchScreenState extends State<RepoSearchScreen> {
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
        child: Text("Waiting"),
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
}

// Widget buildRepoCard(Repo repo) {
//   return Card(
//     elevation: 2.0,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: <Widget>[
//           Text(
//             repo.fullName!,
//             style: TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.w700,
//               fontFamily: 'Palatino',
//             ),
//           )
//         ],
//       ),
//     ),
//   );
//}
