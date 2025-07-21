import '../ApiServiceBase.dart';

class ExpertStoryApis extends ApiServiceBase {
  ExpertStoryApis._();

  static final ExpertStoryApis _instance = ExpertStoryApis._();

  factory ExpertStoryApis() {
    return _instance;
  }

  static ExpertStoryApis get instance => _instance;

  Future<Map<String, dynamic>> getAll(queryParameters) {
    return httpService.get(
      '/api/task/open/expertStory/getAll',
      queryParameters: queryParameters,
    );
  }
}