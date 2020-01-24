import 'package:JapanK/editorpage.dart';
import 'package:flutter/material.dart';
import 'package:JapanK/datamodel.dart';
import 'package:JapanK/utils.dart';

class NoteIcon extends StatefulWidget {
  final String wordId;
  NoteIcon(this.wordId);

  @override
  _NoteIconState createState() => _NoteIconState(wordId);
}

class _NoteIconState extends State<NoteIcon> {
  String wordId;
  Future<String> notes;

  _NoteIconState(this.wordId);

  @override
  initState() {
    super.initState();
    this.notes = getNoteById(wordId);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.description),
      tooltip: "Add notes",
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return FutureBuilder<String>(
              future: getNoteById(wordId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return EditorPage(
                    placeholder: snapshot.data,
                    save: (content) {
                      saveNoteById(wordId, content)
                          .then((onValue) => Toast.toast(context, msg: "Saved"))
                          .catchError(
                              (onError) => Toast.toast(context, msg: onError));
                    },
                  );
                } else if (snapshot.hasError)
                  return ErrorHandler(error: snapshot.error);
                else
                  return Center(child: CircularProgressIndicator());
              });
        }));
      },
    );
  }
}
