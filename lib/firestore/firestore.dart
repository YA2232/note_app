import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesRepository {
  final firestore = FirebaseFirestore.instance;

  String? getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print("No user signed in.");
      return null;
    }
  }

  Future<void> addNote({String? title, String? content}) async {
    String? uid = getCurrentUserUid();

    if (uid != null) {
      await firestore.collection("users").doc(uid).collection("notes").add({
        'title': title,
        'content': content,
      });
    } else {
      print("Cannot add note, user not logged in.");
    }
  }

  Future<void> updateNote({String? title, String? content, String? id}) async {
    String? uid = getCurrentUserUid();

    if (uid != null && id != null) {
      try {
        await firestore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .doc(id)
            .update({
          'title': title,
          'content': content,
        });
        print("Note updated successfully.");
      } catch (e) {
        print("Error updating note: $e");
      }
    } else {
      print("Cannot update note, user not logged in or note ID is null.");
    }
  }

  Stream<QuerySnapshot<Object?>>? getData() {
    String? uid = getCurrentUserUid();
    if (uid != null) {
      return firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .snapshots();
    } else {
      print("Cannot add note, user not logged in.");
    }
  }

  Future<void> deleteNote(String noteId) async {
    String? uid = getCurrentUserUid();
    if (uid != null) {
      try {
        await firestore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .doc(noteId)
            .delete();
        print("Note deleted successfully.");
      } catch (e) {
        print("Error deleting note: $e");
      }
    } else {
      print("Cannot delete note, user not logged in.");
    }
  }
}
