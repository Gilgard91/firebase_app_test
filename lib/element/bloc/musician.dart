import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Musician extends Equatable {
  final String id;
  final String name;
  final int birthYear;
  final String userId;

  const Musician({
    required this.id,
    required this.name,
    required this.birthYear,
    required this.userId,
  });

  factory Musician.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Musician(
      id: doc.id,
      name: data['Nome'] ?? '',
      birthYear: data['Anno di nascita'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'Nome': name,
      'Anno di nascita': birthYear,
      'userId': userId,
    };
  }

  @override
  List<Object?> get props => [id, name, birthYear, userId];
}