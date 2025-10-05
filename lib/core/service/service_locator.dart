import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_app/admin/admin.dart';
import 'package:quiz_app/auth/data/datasource/auth_remote_datasource.dart';
import 'package:quiz_app/auth/data/repository/auth_repository.dart';
import 'package:quiz_app/auth/domain/repository/base_auth_repository.dart';
import 'package:quiz_app/auth/domain/usecase/forgot_password_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/login_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/register_usecase.dart';
import 'package:quiz_app/auth/domain/usecase/reset_password_usecase.dart';
import 'package:quiz_app/auth/presentation/controller/auth/auth_bloc.dart';
import 'package:quiz_app/auth/presentation/controller/password_visibility/password_visibility_cubit.dart';
import 'package:quiz_app/core/error/exceptions.dart';
import 'package:quiz_app/core/network/error_message_model.dart';
import 'package:quiz_app/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton(sharedPreferences);

    getIt.registerSingleton<FlutterSecureStorage>(
      const FlutterSecureStorage(),
    );

    getIt.registerLazySingleton(() {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          contentType: 'application/json',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
      ));

      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final secureStorage = getIt<FlutterSecureStorage>();
          final token = await secureStorage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            throw ServerException(
                errorMessageModel: ErrorMessageModel.fromJson({
              'message': 'Unauthorized: Invalid or expired token',
            }));
          }
          return handler.next(error);
        },
      ));

      return dio;
    });

    getIt.registerFactory(() => PasswordVisibilityCubit());

    //------------ Auth Bloc ----------
    getIt.registerFactory(() => AuthBloc(
          getIt(),
          getIt(),
          getIt(),
          getIt(),
          getIt<SharedPreferences>(),
          getIt<FlutterSecureStorage>(),
        ));

    // ------------ Auth usecase ------------
    getIt.registerLazySingleton(() => LoginUsecase(getIt()));
    getIt.registerLazySingleton(() => RegisterUsecase(getIt()));
    getIt.registerLazySingleton(() => ForgotPasswordUsecase(getIt()));
    getIt.registerLazySingleton(() => ResetPasswordUsecase(getIt()));

    // -------------- Auth Repository -----------
    getIt.registerLazySingleton<BaseAuthRepository>(
      () => AuthRepository(getIt()),
    );

    // ------------ Auth Remote DataSource ------------
    getIt.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDatasource(),
    );

    //------------ User Blocs ----------
    getIt.registerFactory(() => CategoryUserBloc(
          getIt(),
        ));
    getIt.registerFactory(() => QuizUserBloc(getIt()));
    getIt.registerFactory(() => QuestionUserBloc());

    // ------------ User Category usecase ------------
    getIt.registerLazySingleton(() => FetchAllCategories(getIt()));

    // ------------ User Quiz usecase ------------
    getIt.registerLazySingleton(() => FetchQuizzesByCategoryId(getIt()));
    // getIt.registerLazySingleton(() => SearchForCategory(getIt()));

    // -------------- User Repository -----------
    getIt.registerLazySingleton<BaseCategoryRepositoryUser>(
      () => CategoryUserRepository(getIt()),
    );
    getIt.registerLazySingleton<BaseQuizRepositoryUser>(
      () => QuizUserRepository(getIt()),
    );
    // ------------ User Remote DataSource ------------

    getIt.registerLazySingleton<BaseCategoryRemoteDatasourceUser>(
      () => CategoryRemoteDatasourceUser(),
    );
    getIt.registerLazySingleton<BaseQuizRemoteDatasourceUser>(
      () => QuizRemoteDatasourceUser(),
    );

    //------------ Admin Blocs ----------
    getIt.registerFactory(() => QuestionAdminBloc(getIt()));
    getIt.registerFactory(() => StatisticsAdminBloc(getIt(), getIt(), getIt()));
    getIt.registerFactory(
        () => CategoryAdminBloc(getIt(), getIt(), getIt(), getIt()));
    getIt.registerFactory(() => QuizAdminBloc(
        getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()));

    // ------------ Admin Question usecase ------------
    getIt.registerLazySingleton(() => DeleteQuesetion(getIt()));

    // ------------ Admin Quiz usecase ------------
    getIt.registerLazySingleton(() => GetAllQuizzes(getIt()));
    getIt.registerLazySingleton(() => GetAllQuizzesByCategoryId(getIt()));
    getIt.registerLazySingleton(() => SearchQuiz(getIt()));
    getIt.registerLazySingleton(() => AddQuiz(getIt()));
    getIt.registerLazySingleton(() => DeleteQuiz(getIt()));
    getIt.registerLazySingleton(() => UpdateQuiz(getIt()));

    // ------------ Admin Category usecase ------------
    getIt.registerLazySingleton(() => GetAllCategories(getIt()));
    getIt.registerLazySingleton(() => AddCategory(getIt()));
    getIt.registerLazySingleton(() => DeleteCategory(getIt()));
    getIt.registerLazySingleton(() => UpdateCategory(getIt()));

    // --------------Admin Repository -----------

    getIt.registerLazySingleton<BaseQuestionRepositoryAdmin>(
      () => QuestionRepositoryAdmin(getIt()),
    );

    getIt.registerLazySingleton<BaseQuizRepositoryAdmin>(
      () => QuizzesRepositoryAdmin(getIt()),
    );

    getIt.registerLazySingleton<BaseCategoryRepositoryAdmin>(
      () => CategoriesRepositoryAdmin(getIt()),
    );

    // ------------ Admin Remote DataSource ------------

    getIt.registerLazySingleton<BaseQuestionRemoteDatasourceAdmin>(
      () => QuestionRemoteDatasourceAdmin(),
    );

    getIt.registerLazySingleton<BaseQuizRemoteDatasourceAdmin>(
      () => QuizRemoteDatasourceAdmin(),
    );

    getIt.registerLazySingleton<BaseCategoryRemoteDatasourceAdmin>(
      () => CategoryRemoteDatasourceAdmin(),
    );
  }
}
