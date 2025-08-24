import 'dart:convert';

import 'package:http/http.dart' as http;

import '../element/bloc/book.dart';

class BookApiService {
  static const String baseUrl = 'http://192.168.1.2:8080/api';

  static Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  static Future<void> deleteBook(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/books/$id'));

      if (response.statusCode == 200) {

      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }
}