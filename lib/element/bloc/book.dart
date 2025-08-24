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

  Book({
    this.id,
    required this.title,
    this.description,
    this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);


  Map<String, dynamic> toJsonWithoutId() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  Book copyWith({
    int? id,
    String? title,
    String? description,
    String? author,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, description: $description, author: $author}';
  }
}