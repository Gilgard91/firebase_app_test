import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class Book {
  @JsonKey(defaultValue: 0)
  final int? id;

  @JsonKey(defaultValue: "")
  final String? title;

  @JsonKey(defaultValue: "")
  final String? description;

  @JsonKey(defaultValue: "")
  final String? author;

  @JsonKey(defaultValue: "")
  final String? thumbnail;

  @JsonKey(defaultValue: "")
  final String? publishedDate;

  Book({
    this.id,
    required this.title,
    this.description,
    this.author,
    this.thumbnail,
    this.publishedDate,
  });

  factory Book.fromGoogleBooksJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final authors = volumeInfo['authors'] as List<dynamic>?;
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;

    return Book(
      title: volumeInfo['title'] as String? ?? "",
      description: volumeInfo['description'] as String? ?? "",
      author: authors?.isNotEmpty == true ? authors!.first as String : "",
      thumbnail: imageLinks?['thumbnail'] as String? ?? "",
      publishedDate: volumeInfo['publishedDate'] as String? ?? "",
    );
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);


  Book copyWith({
    int? id,
    String? title,
    String? description,
    String? author,
    String? thumbnail,
    String? publishedDate,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      thumbnail: thumbnail ?? this.thumbnail,
      publishedDate: publishedDate ?? this.publishedDate,
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, description: $description, author: $author, thumbnail: $thumbnail, publishedDate: $publishedDate}';
  }
}