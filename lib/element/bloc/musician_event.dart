import 'package:equatable/equatable.dart';

abstract class MusiciansEvent extends Equatable {
  const MusiciansEvent();

  @override
  List<Object?> get props => [];
}

class LoadMusicians extends MusiciansEvent {
  final String userId;

  const LoadMusicians({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddMusician extends MusiciansEvent {
  final String name;
  final int birthYear;
  final String userId;

  const AddMusician({
    required this.name,
    required this.birthYear,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, birthYear, userId];
}

class DeleteMusician extends MusiciansEvent {
  final String musicianId;

  const DeleteMusician({required this.musicianId});

  @override
  List<Object?> get props => [musicianId];
}

class MusiciansSubscriptionRequested extends MusiciansEvent {
  final String userId;

  const MusiciansSubscriptionRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}