// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  author: json['author'] as String? ?? '',
  thumbnail: json['thumbnail'] as String? ?? '',
  publishedDate: json['publishedDate'] as String? ?? '',
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'author': instance.author,
  'thumbnail': instance.thumbnail,
  'publishedDate': instance.publishedDate,
};
