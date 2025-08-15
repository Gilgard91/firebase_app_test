import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'musician.dart';
import 'musician_event.dart';
import 'musician_state.dart';

class MusiciansBloc extends Bloc<MusiciansEvent, MusiciansState> {
  final FirebaseFirestore _firestore;
  StreamSubscription<QuerySnapshot>? _musiciansSubscription;

  MusiciansBloc({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(MusiciansInitial()) {

    on<LoadMusicians>(_onLoadMusicians);
    on<AddMusician>(_onAddMusician);
    on<DeleteMusician>(_onDeleteMusician);
    on<MusiciansSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onLoadMusicians(
      LoadMusicians event,
      Emitter<MusiciansState> emit,
      ) async {
    emit(MusiciansLoading());
    try {
      final querySnapshot = await _firestore
          .collection('Musicisti')
          .where('userId', isEqualTo: event.userId)
          .get();

      final musicians = querySnapshot.docs
          .map((doc) => Musician.fromFirestore(doc))
          .toList();

      emit(MusiciansLoaded(musicians: musicians));
    } catch (e) {
      emit(MusiciansError(message: 'Errore nel caricamento: $e'));
    }
  }

  Future<void> _onAddMusician(
      AddMusician event,
      Emitter<MusiciansState> emit,
      ) async {
    try {
      final musician = Musician(
        id: '', // Firestore genererà l'ID
        name: event.name,
        birthYear: event.birthYear,
        userId: event.userId,
      );

      await _firestore.collection('Musicisti').add(musician.toFirestore());

      // Mantieni la lista corrente e aggiungi il messaggio di successo
      final currentState = state;
      if (currentState is MusiciansLoaded) {
        emit(MusicianAdded(
          message: 'Musicista aggiunto con successo!',
          musicians: currentState.musicians,
        ));
      } else {
        emit(const MusicianAdded(
          message: 'Musicista aggiunto con successo!',
          musicians: [],
        ));
      }

      // Lo stream si aggiornerà automaticamente con i nuovi dati
    } catch (e) {
      emit(MusiciansError(message: 'Errore nell\'aggiunta: $e'));
    }
  }

  Future<void> _onDeleteMusician(
      DeleteMusician event,
      Emitter<MusiciansState> emit,
      ) async {
    try {
      await _firestore
          .collection('Musicisti')
          .doc(event.musicianId)
          .delete();

      // Il stream si aggiornerà automaticamente
    } catch (e) {
      emit(MusiciansError(message: 'Errore nella cancellazione: $e'));
    }
  }

  Stream<int> testStream() async* {
    for (int i = 1; i <= 10; i++) {
      debugPrint("sendo il numero $i");
      await Future.delayed(Duration(seconds: 2));
      yield i;
    }
  }

  Future<void> _onSubscriptionRequested(
      MusiciansSubscriptionRequested event,
      Emitter<MusiciansState> emit,
      ) async {
    emit(MusiciansLoading());
    Stream<int> stream = testStream();
    stream.listen((data) {
      debugPrint("ricevuto il numero $data");
    });
    await _musiciansSubscription?.cancel();

    // Usa emit.forEach per gestire gli stream in modo sicuro
    await emit.forEach<QuerySnapshot>(
      _firestore
          .collection('Musicisti')
          .where('userId', isEqualTo: event.userId)
          .snapshots(),
      onData: (snapshot) {
        final musicians = snapshot.docs
            .map((doc) => Musician.fromFirestore(doc))
            .toList();
        return MusiciansLoaded(musicians: musicians);
      },
      onError: (error, stackTrace) {
        return MusiciansError(message: 'Errore nel caricamento: $error');
      },
    );
  }

  @override
  Future<void> close() {
    // Non serve più cancellare _musiciansSubscription
    // perché emit.forEach lo gestisce automaticamente
    return super.close();
  }
}