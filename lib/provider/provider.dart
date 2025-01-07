import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/firestore/firestore.dart';

class ProviderNote extends ChangeNotifier {
  NotesRepository firestore = NotesRepository();

  Future<void> addNote({String? title, String? content}) async {
    await firestore.addNote(title: title, content: content);
    notifyListeners();
  }

  Future<void> updateNote({String? title, String? content, String? id}) async {
    await firestore.updateNote(title: title, content: content, id: id);
    notifyListeners();
  }

  Stream<QuerySnapshot<Object?>>? getData() {
    return firestore.getData();
  }

  Future<void> deleteNote(String noteId) async {
    await firestore.deleteNote(noteId);
    notifyListeners();
  }
}
