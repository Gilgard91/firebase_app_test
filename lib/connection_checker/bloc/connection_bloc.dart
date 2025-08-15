import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionStateTest> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectionBloc() : super(ConnectionInitial()) {
    on<CheckConnection>(_onConnectionCheckRequested);

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      add(CheckConnection());
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }



  Future<void> _onConnectionCheckRequested(
      CheckConnection event,
      Emitter<ConnectionStateTest> emit,
      ) async {
    String message = '';

    var connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults.isEmpty || connectivityResults.contains(ConnectivityResult.none)) {
      message = 'Nessuna connessione';
    } else if (connectivityResults.contains(ConnectivityResult.wifi)) {
      message = 'Connesso tramite WiFi';
    } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
      message = 'Connesso tramite rete mobile';
    } else if (connectivityResults.contains(ConnectivityResult.ethernet)) {
      message = 'Connesso tramite Ethernet';
    } else {
      message = 'Connessione sconosciuta';
    }

    emit(CurrentConnection(message: message));
  }
}