import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';

class EditorPage extends StatefulWidget {
  EditorPage({this.placeholder = "", @required this.save});
  final String placeholder;
  final Function(String) save;

  @override
  _EditorPageState createState() => _EditorPageState(placeholder, save);
}

class _EditorPageState extends State<EditorPage> {
  _EditorPageState(this.placeholder, this.save);
  String placeholder;
  Function(String) save;

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveDocument(context),
          )
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    //placeholder
    try {
      return NotusDocument.fromJson(json.decode(placeholder));
    } catch (e) {
      //in case it is blank
      return NotusDocument();
    }
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);
    this.save(contents);
  }
}
