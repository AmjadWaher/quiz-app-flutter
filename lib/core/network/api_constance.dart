class ApiConstance {
  static const String baseUrl = 'http://quizzesapi.runasp.net/api';

  static const String loginPath = '$baseUrl/Account/login';
  static const String registerPath = '$baseUrl/Account/register';
  static const String resetPassword = '$baseUrl/Account/reset-password';

  static const String forgotPassword = '$baseUrl/Account/forgotpassword';

  static const String categoryPath = '$baseUrl/Categories';
  static String quizAdminPath(String userId) => '$baseUrl/Quizzes/$userId';
  static const String quizPath = '$baseUrl/Quizzes';

  static String categoryByIdPath(int id) => '$categoryPath/$id';
  static String searchForCategories(String name) =>
      '$categoryPath/Search/$name';

  static String deleteQuizPath(int quizId, String userId) =>
      '$quizAdminPath/$quizId,$quizId';
  static String quizByIdPath(int id) => '$quizPath/$id';
  static String searchQuiz(String title) => '$quizPath/Search/$title';
  static String quizByCategoryIdPath(int id) => '$quizPath/ByCategory/$id';

  static String questionByIdPath(int id) => '$baseUrl/Question/$id';
}
