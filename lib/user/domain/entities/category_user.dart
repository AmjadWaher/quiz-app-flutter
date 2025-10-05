import 'package:equatable/equatable.dart';

class CategoryUser extends Equatable {
  final int id;
  final String name;
  final String description;

  const CategoryUser({
    required this.id,
    required this.name,
    required this.description,}
  );

  @override
  List<Object> get props => [
        id,
        name,
        description,
      ];
}
