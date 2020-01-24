import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/navigationbar.dart';
import 'datamodel.dart';
import 'package:JapanK/worditem.dart';
import 'package:JapanK/utils.dart';

enum Action { import, outport }
enum Method { clipboard, file }

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Future<List<String>> allWordId;

  @override
  void initState() {
    super.initState();
    allWordId = allNotesId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: allWordId,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: NavigationBar(context,
                    title: "Notes",
                    fontFactor: 1.5,
                    actions: [
                      PopupMenuButton<Action>(
                        onSelected: (result) {
                          switch (result) {
                            case Action.import:
                              _askedToIOport(import: true);
                              break;
                            case Action.outport:
                              _askedToIOport(import: false);
                              break;
                          }
                        },
                        itemBuilder: (context) => <PopupMenuEntry<Action>>[
                          const PopupMenuItem<Action>(
                            value: Action.import,
                            child: ListTile(
                              leading: Icon(Icons.file_upload),
                              title: Text("Import"),
                            ),
                          ),
                          const PopupMenuItem<Action>(
                            value: Action.outport,
                            child: ListTile(
                              leading: Icon(Icons.file_download),
                              title: Text("Outport"),
                            ),
                          )
                        ],
                      )
                    ]),
                body: Container(
                    margin: EdgeInsets.only(top: STDFONTSIZE),
                    child: RefreshIndicator(
                        onRefresh: updateCollection,
                        child: ListView(
                          children: <Widget>[
                            wordlistBuilder(snapshot.data.toSet())
                          ],
                        ))));
          } else if (snapshot.hasError) {
            return Text("errors: ${snapshot.error}");
          } else
            return CircularProgressIndicator();
        });
  }

  Future<void> updateCollection() async {
    setState(() {
      this.allWordId = allNotesId();
    });
    return null;
  }

  Future<void> _askedToIOport({@required bool import}) async {
    switch (await showDialog<Method>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(import ? "Import from ... " : "Outport to ..."),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Method.clipboard);
                },
                child: ListTile(
                  leading: Icon(Icons.content_paste),
                  title: Text("Clipboard"),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Method.file);
                },
                child: ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text("File"),
                ),
              )
            ],
          );
        })) {
      case Method.clipboard:
        if (import) {
          await Clipboard.getData(Clipboard.kTextPlain).then((onValue) {
            addNotesFromString(onValue.text);
            Toast.toast(context,
                msg: "Successfully imported, drag down to refresh");
          }).catchError((error) {
            Toast.toast(context, msg: "Failed: $error");
          });
          setState(() {
            allWordId = allNotesId();
          });
        } else {
          await outportNotesToString().then((dataString) {
            Clipboard.setData(ClipboardData(text: dataString));
            Toast.toast(context, msg: "Successfully outport to clipboard");
          }).catchError((error) {
            Toast.toast(context, msg: "Failed: $error");
          });
        }
        break;
      case Method.file:
        if (import) {
          FilePicker.getFile().then((file) {
            if (file == null) return;
            addNotesFromString(file.readAsStringSync());
            setState(() {
              allWordId = allNotesId();
            });
            Toast.toast(context,
                msg: "Successfully imported from ${file.path}");
          }).catchError((error) {
            Toast.toast(context, msg: "$error");
          });
        } else {
          outportNotesToFile("notes_outport.txt").then((filePath) {
            Toast.toast(context, msg: "Outport to $filePath");
          }).catchError((error) {
            Toast.toast(context, msg: "$error");
          });
        }
        break;
    }
  }
}
