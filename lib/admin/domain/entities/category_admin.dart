import 'package:equatable/equatable.dart';

class CategoryAdmin extends Equatable {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  const CategoryAdmin({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
        id,
        name,
        description,
        createdAt,
      ];
}
