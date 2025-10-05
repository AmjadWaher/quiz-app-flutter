import 'package:dio/dio.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/api_constance.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/core/service/service_locator.dart';

abstract class BaseQuestionRemoteDatasourceAdmin {
  Future<void> deleteQuestion(int id);
}

class QuestionRemoteDatasourceAdmin
    implements BaseQuestionRemoteDatasourceAdmin {
  @override
  Future<void> deleteQuestion(int id) async {
    final response =
        await getIt<Dio>().delete(ApiConstance.questionByIdPath(id));

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}
