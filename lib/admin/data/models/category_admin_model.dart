import 'package:quiz_app/admin/domain/entities/category_admin.dart';

class CategoryAdminModel extends CategoryAdmin {
  const CategoryAdminModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  CategoryAdminModel copyWith({
    String? name,
    String? description,
  }) {
    return CategoryAdminModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
    );
  }

  factory CategoryAdminModel.fromJson(Map<String, dynamic> json) => CategoryAdminModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
    };
  }
}
