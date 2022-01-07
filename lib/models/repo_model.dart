import 'package:github_repos/models/repo.dart';
import 'package:json_annotation/json_annotation.dart';
part 'repo_model.g.dart';

@JsonSerializable()
class APIRepoQuery {
  factory APIRepoQuery.fromJson(Map<String, dynamic> json) =>
      _$APIRepoQueryFromJson(json);

  Map<String, dynamic> toJson() => _$APIRepoQueryToJson(this);

  @JsonKey(name: 'total_count')
  int reposCount;
  @JsonKey(name: 'items')
  List<Repo> repos;

  APIRepoQuery({
    this.reposCount = 0,
    required this.repos,
  });
}
