part of 'connection_bloc.dart';

@immutable
sealed class ConnectionStateTest {}

final class ConnectionInitial extends ConnectionStateTest {}

class CurrentConnection extends ConnectionStateTest {
  final String message;

  CurrentConnection({required this.message});
}