import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/provider/provider.dart';
import 'package:notes_app/view/add_note.dart';
import 'package:notes_app/view/note_card.dart';
import 'package:notes_app/view/signin_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeScreen = 'hpmescreen';
  final firebase = FirebaseAuth.instance;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<ProviderNote>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 20,
          onPressed: () {
            Navigator.pushNamed(context, AddNote.routeScreen);
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notes"),
              TextButton(
                  onPressed: () {
                    firebase.signOut();
                    Navigator.pushNamed(context, SigninScreen.routeScreen);
                  },
                  child: Text("Sign Out"))
              // Icon(Icons.list_alt),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder<QuerySnapshot<Object?>>(
                stream: noteProvider.getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No notes found."));
                  }
                  var notes = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onLongPress: () {
                            noteProvider.deleteNote(notes[i].id);
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddNote(
                                          title: notes[i]['title'],
                                          note: notes[i]['content'],
                                          id: notes[i].id,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: noteCard(
                              title: notes[i]['title'],
                              note: notes[i]['content'],
                            ),
                          ),
                        );
                      });
                })));
  }
}
