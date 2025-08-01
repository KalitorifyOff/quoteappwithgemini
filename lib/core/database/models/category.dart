import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String name;
  final bool isUserCreated;

  const Category({
    this.id,
    required this.name,
    this.isUserCreated = false,
  });

  @override
  List<Object?> get props => [id, name, isUserCreated];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_user_created': isUserCreated ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      isUserCreated: map['is_user_created'] == 1,
    );
  }

  Category copyWith({
    int? id,
    String? name,
    bool? isUserCreated,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      isUserCreated: isUserCreated ?? this.isUserCreated,
    );
  }
}
