import 'package:github_repos/models/repo_owner.dart';
import 'package:json_annotation/json_annotation.dart';
part 'repo.g.dart';

@JsonSerializable()
class Repo {
  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);

  Map<String, dynamic> toJson() => _$RepoToJson(this);

  @JsonKey(name: 'full_name')
  String fullName;
  @JsonKey(name: 'created_at')
  String dateCreated;
  @JsonKey(name: 'updated_at')
  String dateLastUpdated;
  @JsonKey(name: 'stargazers_count')
  int star;
  @JsonKey(name: 'language')
  String programmingLanguage;
  @JsonKey(name: 'forks_count')
  int forks;
  RepoOwner owner;

  Repo(
      {required this.fullName,
      required this.dateCreated,
      required this.dateLastUpdated,
      required this.star,
      required this.programmingLanguage,
      required this.forks,
      required this.owner});
}