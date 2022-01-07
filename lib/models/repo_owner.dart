import 'package:json_annotation/json_annotation.dart';
part 'repo_owner.g.dart';

@JsonSerializable()
class RepoOwner {
  factory RepoOwner.fromJson(Map<String, dynamic> json) =>
      _$RepoOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$RepoOwnerToJson(this);

  @JsonKey(name: 'login')
  String name;
  @JsonKey(name: 'avatar_url')
  String avatarURL;
  String type;

  RepoOwner({
    required this.name,
    required this.avatarURL,
    required this.type,
  });
}
