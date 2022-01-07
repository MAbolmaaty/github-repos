import 'package:flutter/material.dart';
import 'package:github_repos/app_theme.dart';
import 'package:github_repos/screens/home_screen.dart';

void main() {
  runApp(const GithupReposApp());
}

class GithupReposApp extends StatelessWidget {
  const GithupReposApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.light();
    return MaterialApp(
      title: 'Github Repos',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}
