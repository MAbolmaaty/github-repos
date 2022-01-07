// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIRepoQuery _$APIRepoQueryFromJson(Map<String, dynamic> json) => APIRepoQuery(
      reposCount: json['total_count'] as int,
      repos: (json['items'] as List<dynamic>)
          .map((e) => Repo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$APIRepoQueryToJson(APIRepoQuery instance) =>
    <String, dynamic>{
      'total_count': instance.reposCount,
      'items': instance.repos,
    };
