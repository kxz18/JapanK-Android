import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:JapanK/datamodel.dart';
import 'wordcard.dart';

class SearchResultPage extends StatefulWidget {
  SearchResultPage({@required this.id});
  final String id;
  @override
  _SearchResultPageState createState() => _SearchResultPageState(this.id);
}

class _SearchResultPageState extends State<SearchResultPage> {
  _SearchResultPageState(this.id);
  final String id;
  Future<Post> wordData;


  @override
  void initState() {
    super.initState();
    this.wordData = fetchPost(this.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Post> (
      future: this.wordData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WordCard(wordInfo: snapshot.data);
        } else if (snapshot.hasError) {
          return Text("Oops, error: ${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
}