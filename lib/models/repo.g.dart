// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo(
      fullName: json['full_name'] as String? ?? "",
      dateCreated: json['created_at'] as String? ?? "",
      dateLastUpdated: json['updated_at'] as String? ?? "",
      star: json['stargazers_count'] as int? ?? 0,
      programmingLanguage: json['language'] as String? ?? "",
      forks: json['forks_count'] as int? ?? 0,
      owner: RepoOwner.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'full_name': instance.fullName,
      'created_at': instance.dateCreated,
      'updated_at': instance.dateLastUpdated,
      'stargazers_count': instance.star,
      'language': instance.programmingLanguage,
      'forks_count': instance.forks,
      'owner': instance.owner,
    };
