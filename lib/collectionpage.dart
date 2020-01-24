import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/navigationbar.dart';
import 'package:JapanK/recitepage.dart';
import 'package:JapanK/searchbar.dart';
import 'datamodel.dart';
import 'package:JapanK/worditem.dart';
import 'package:JapanK/utils.dart';

enum Action { recite, import, outport }
enum Method { clipboard, file }

class CollectionPage extends StatefulWidget {
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  Future<Set<String>> allWordId;

  @override
  void initState() {
    super.initState();
    allWordId = allInCollection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
        future: allWordId,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: NavigationBar(context,
                    title: "Collection",
                    fontFactor: 1.5,
                    actions: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          tooltip: "Back",
                          onPressed: () => Navigator.pop(context)),
                      SearchIcon(),
                      PopupMenuButton<Action>(
                        onSelected: (result) {
                          switch (result) {
                            case Action.recite:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      RecitePage(ids: snapshot.data)));
                              break;
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
                            value: Action.recite,
                            child: ListTile(
                              leading: Icon(Icons.library_books),
                              title: Text("Recite words"),
                            ),
                          ),
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
                drawer: Menu(context, onCollection: true),
                body: Container(
                    margin: EdgeInsets.only(top: STDFONTSIZE),
                    child: RefreshIndicator(
                        onRefresh: updateCollection,
                        child: ListView(children: <Widget>[
                          wordlistBuilder(snapshot.data)
                        ]))));
          } else if (snapshot.hasError) {
            return Text("errors: ${snapshot.error}");
          } else
            return CircularProgressIndicator();
        });
  }

  Future<void> updateCollection() async {
    setState(() {
      this.allWordId = allInCollection();
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
            addCollectionFromString(onValue.text);
            Toast.toast(context,
                msg: "Successfully imported, drag down to refresh");
          }).catchError((error) {
            Toast.toast(context, msg: "Failed: $error");
          });
          setState(() {
            allWordId = allInCollection();
          });
        } else {
          await allInCollection().then((items) {
            String allItems = "";
            for (String item in items) allItems += item + "\n";
            Clipboard.setData(ClipboardData(text: allItems));
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
            addCollectionFromString(file.readAsStringSync());
            setState(() {
              allWordId = allInCollection();
            });
            Toast.toast(context,
                msg: "Successfully imported from ${file.path}", showTime: 2000);
          }).catchError((error) {
            Toast.toast(context, msg: "$error");
          });
        } else {
          outportCollection("collection_outport.txt").then((filePath) {
            Toast.toast(context, msg: "Outport to $filePath", showTime: 5000);
          }).catchError((error) {
            Toast.toast(context, msg: "$error");
          });
        }
        break;
    }
  }
}
