import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../element/bloc/book.dart';

class BookApiService {
  static const String googleAPIUrl = 'https://www.googleapis.com/books/v1/volumes?q=subject:';
  static const String backendUrl = 'http://192.168.4.66:8080/api';
  static const Duration _timeout = Duration(milliseconds: 3000);

  static Future<List<Book>> getBooks({String? subject}) async {
    try {
      final String url = '$googleAPIUrl${subject ?? 'adventure'}&maxResults=40';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['items'] != null) {
          final List<dynamic> jsonList = jsonResponse['items'] as List<dynamic>;
          return jsonList.map((json) => Book.fromGoogleBooksJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('err: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('err: $e');
    }
  }

  static Future<List<Book>> getBooksBackend() async {
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/books'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Book.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('err: $e');
      return [];
    }
  }

  static Future<void> deleteBook(int id) async {
    try {
      final response = await http.delete(Uri.parse('$backendUrl/books/$id'));

      if (response.statusCode == 200) {

      } else {
        throw Exception('err: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('err: $e');
    }
  }

  static Future<void> addBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/books'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(book),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Libro aggiunto con successo');
      } else {
        throw Exception('Errore: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Errore: $e');
    }
  }
}