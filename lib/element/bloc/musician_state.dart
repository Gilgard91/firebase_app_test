import 'package:equatable/equatable.dart';

import 'musician.dart';

abstract class MusiciansState extends Equatable {
  const MusiciansState();

  @override
  List<Object?> get props => [];
}

class MusiciansInitial extends MusiciansState {}

class MusiciansLoading extends MusiciansState {}

class MusiciansLoaded extends MusiciansState {
  final List<Musician> musicians;

  const MusiciansLoaded({required this.musicians});

  @override
  List<Object?> get props => [musicians];
}

class MusiciansError extends MusiciansState {
  final String message;

  const MusiciansError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MusicianAdded extends MusiciansLoaded {
  final String message;

  const MusicianAdded({
    required this.message,
    required List<Musician> musicians,
  }) : super(musicians: musicians);

  @override
  List<Object?> get props => [message, musicians];
}