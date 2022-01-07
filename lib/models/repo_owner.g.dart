// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepoOwner _$RepoOwnerFromJson(Map<String, dynamic> json) => RepoOwner(
      name: json['login'] as String? ?? "",
      avatarURL: json['avatar_url'] as String? ?? "",
      type: json['type'] as String? ?? "",
    );

Map<String, dynamic> _$RepoOwnerToJson(RepoOwner instance) => <String, dynamic>{
      'login': instance.name,
      'avatar_url': instance.avatarURL,
      'type': instance.type,
    };
