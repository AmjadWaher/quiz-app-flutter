import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/admin/admin.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/api_constance.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/core/service/service_locator.dart';

abstract class BaseQuizRemoteDatasourceAdmin {
  Future<List<QuizAdminModel>> getAllQuizzes(String userId);
  Future<List<QuizAdminModel>> getAllQuizzesByCategoryId(int id);
  Future<List<QuizAdminModel>> searchQuiz(SearchParameters parameters);
  Future<QuizAdminModel> addQuiz(QuizParameters parameters);
  Future<QuizAdminModel> updateQuiz(QuizParameters parameters);
  Future<void> deleteQuiz(DeleteQuizParameters parameters);
}

class QuizRemoteDatasourceAdmin extends BaseQuizRemoteDatasourceAdmin {
  @override
  Future<List<QuizAdminModel>> getAllQuizzes(String userId) async {
    final response = await getIt<Dio>().get(ApiConstance.quizAdminPath(userId));
    if (response.statusCode == 200) {
      return List<QuizAdminModel>.from(
        (response.data as List).map((json) => QuizAdminModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<QuizAdminModel> addQuiz(QuizParameters parameters) async {
    final response = await getIt<Dio>().post(ApiConstance.quizPath, data: {
      'title': parameters.title,
      'categoryId': parameters.categoryId,
      'timeLimit': parameters.timeLimit,
      'userId': parameters.userId,
      'questions': List<Map<String, dynamic>>.from(
        parameters.questions.map(
          (question) => {
            'title': question.title,
            'answers': List<Map<String, dynamic>>.from(
              question.options.map(
                (option) {
                  log(option.text);
                  return {
                    'text': option.text,
                  };
                },
              ),
            ),
            'currectOptionIndex': question.correctOptionIndex,
          },
        ),
      ),
    });

    if (response.statusCode == 200) {
      return QuizAdminModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<QuizAdminModel>> getAllQuizzesByCategoryId(int id) async {
    final userId = await getIt<FlutterSecureStorage>().read(key: 'id');
    final response = await getIt<Dio>()
        .get(ApiConstance.quizByCategoryIdPath(id), queryParameters: {
      if (userId != null) 'userId': userId,
    });
    if (response.statusCode == 200) {
      return List<QuizAdminModel>.from(
        (response.data as List).map((json) => QuizAdminModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<List<QuizAdminModel>> searchQuiz(SearchParameters parameters) async {
    final response = await getIt<Dio>().get(
      ApiConstance.searchQuiz(parameters.title),
      queryParameters: {
        if (parameters.categoryId != null) 'categoryId': parameters.categoryId!,
        if (parameters.userId != null) 'userId': parameters.userId!,
      },
    );
    if (response.statusCode == 200) {
      return List<QuizAdminModel>.from(
        (response.data as List).map((json) => QuizAdminModel.fromJson(json)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<void> deleteQuiz(DeleteQuizParameters parameters) async {
    final response = await getIt<Dio>().delete(
        ApiConstance.deleteQuizPath(parameters.quizId, parameters.userId));
    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<QuizAdminModel> updateQuiz(QuizParameters parameters) async {
    final response = await getIt<Dio>()
        .put(ApiConstance.quizByIdPath(parameters.id!), data: {
      'title': parameters.title,
      'categoryId': parameters.categoryId,
      'timeLimit': parameters.timeLimit,
      'userId': parameters.userId,
      'questions': List<Map<String, dynamic>>.from(
        parameters.questions.map(
          (question) => {
            'questionId': question.id,
            'title': question.title,
            'answers': List<Map<String, dynamic>>.from(
                question.options.map((option) => {
                      'answerId': option.id,
                      'text': option.text,
                    })),
            'currectOptionIndex': question.correctOptionIndex,
          },
        ),
      ),
    });
    if (response.statusCode == 200) {
      return QuizAdminModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}
