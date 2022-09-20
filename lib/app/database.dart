import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get collectionReference => _firestore
      .collection("notes")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("Note documents");

  CollectionReference<Note> get collectionRef =>
      collectionReference.withConverter<Note>(
        fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  Stream<List<Note>> get streamReference => collectionRef
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs.map((e) => e.data()).toList());

  void addNote(String docPath, Note note) {
    collectionRef.doc(docPath).set(note);
  }

  void deleteNote(String docPath) {
    collectionReference.doc(docPath).delete();
  }

  void updateNote(String docPath, Map<String, Object?> data) {
    collectionReference.doc(docPath).update(data);
  }
}
