import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/provider/provider.dart';
import 'package:provider/provider.dart';

class AddNote extends StatelessWidget {
  static const String routeScreen = 'addnote';
  String? title;
  String? note;
  String? id;

  AddNote({super.key, this.note, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderNote>(context);
    TextEditingController titleController =
        TextEditingController(text: title ?? '');
    TextEditingController noteController =
        TextEditingController(text: note ?? '');

    return WillPopScope(
      onWillPop: () async {
        if (id != null) {
          await provider.updateNote(
            id: id,
            title: titleController.text,
            content: noteController.text,
          );
        } else {
          await provider.addNote(
            title: titleController.text,
            content: noteController.text,
          );
        }
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.add_alert_outlined),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                    controller: titleController,
                    onChanged: (value) {
                      title = value;
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle:
                          TextStyle(fontSize: 20, color: Colors.grey[500]),
                      border: InputBorder.none,
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: noteController,
                    autofocus: true,
                    onChanged: (value) {
                      note = value;
                    },
                    maxLines: null,
                    decoration: InputDecoration(
                      hintStyle:
                          TextStyle(fontSize: 20, color: Colors.grey[500]),
                      hintText: "Note",
                      border: InputBorder.none,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
