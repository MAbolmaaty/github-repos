import 'package:chopper/chopper.dart';
import 'package:github_repos/models/repo_model.dart';
import 'package:github_repos/network/model_converter.dart';
import 'package:github_repos/network/model_response.dart';
part 'repos_service.chopper.dart';

const String apiUrl = "https://api.github.com";

@ChopperApi()
abstract class ReposService extends ChopperService {
  @Get(path: 'search/repositories')
  Future<Response<Result<APIRepoQuery>>> queryRepos(@Query('q') String query);

  static ReposService create() {
    final client = ChopperClient(
        baseUrl: apiUrl,
        interceptors: [HttpLoggingInterceptor()],
        converter: ModelConverter(),
        errorConverter: const JsonConverter(),
        services: [
          _$ReposService(),
        ]);

    return _$ReposService(client);
  }
}
