import 'package:quiz_app/user/domain/entities/category_user.dart';

class CategoryUserModel extends CategoryUser {
  const CategoryUserModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory CategoryUserModel.fromJson(Map<String, dynamic> json) =>
      CategoryUserModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
      );
}
