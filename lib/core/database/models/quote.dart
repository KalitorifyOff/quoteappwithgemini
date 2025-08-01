import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final int? id;
  final String content;
  final String author;
  final int? categoryId;
  final bool isFavorite;
  final bool isUserCreated;

  const Quote({
    this.id,
    required this.content,
    required this.author,
    this.categoryId,
    this.isFavorite = false,
    this.isUserCreated = false,
  });

  @override
  List<Object?> get props => [id, content, author, categoryId, isFavorite, isUserCreated];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'category_id': categoryId,
      'is_favorite': isFavorite ? 1 : 0,
      'is_user_created': isUserCreated ? 1 : 0,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      content: map['content'],
      author: map['author'],
      categoryId: map['category_id'],
      isFavorite: map['is_favorite'] == 1,
      isUserCreated: map['is_user_created'] == 1,
    );
  }

  Quote copyWith({
    int? id,
    String? content,
    String? author,
    int? categoryId,
    bool? isFavorite,
    bool? isUserCreated,
  }) {
    return Quote(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
      isUserCreated: isUserCreated ?? this.isUserCreated,
    );
  }
}
