import 'package:dio/dio.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/api_constance.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/core/service/service_locator.dart';
import 'package:quiz_app/user/data/models/quiz_user_model.dart';

abstract class BaseQuizRemoteDatasourceUser {
  Future<List<QuizUserModel>> getQuizzesByCategoryId(int id);
}

class QuizRemoteDatasourceUser extends BaseQuizRemoteDatasourceUser {
  @override
  Future<List<QuizUserModel>> getQuizzesByCategoryId(int id) async {
    final response =
        await getIt<Dio>().get(ApiConstance.quizByCategoryIdPath(id));
    if (response.statusCode == 200) {
      return List<QuizUserModel>.from(
        (response.data as List).map((json) => QuizUserModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

}
