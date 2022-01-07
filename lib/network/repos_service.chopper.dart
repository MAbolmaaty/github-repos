// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repos_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ReposService extends ReposService {
  _$ReposService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ReposService;

  @override
  Future<Response<Result<APIRepoQuery>>> queryRepos(String query) {
    final $url = 'search/repositories';
    final $params = <String, dynamic>{'q': query};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<Result<APIRepoQuery>, APIRepoQuery>($request);
  }
}
