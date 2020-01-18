import 'package:flutter/material.dart';
import 'package:JapanK/global.dart';
import 'datamodel.dart';

class Star extends StatefulWidget {
  final String wordId;
  Star(this.wordId);
  @override
  _StarState createState() => _StarState(wordId);
}

class _StarState extends State<Star> {
  final String wordId;
  Future<bool> inCollection;
  _StarState(this.wordId);

  @override
  Widget build(BuildContext context) {
    inCollection = checkInCollection(wordId);
    return FutureBuilder<bool>(
      future: inCollection,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return IconButton(
            icon: snapshot.data ? Icon(Icons.star, color: Colors.yellow) :
                  Icon(Icons.star_border),
            iconSize: 2*STDFONTSIZE,
            onPressed: () {
              setState(() {
                if (!(snapshot.data)) addCollection(wordId);
                else removeCollection(wordId);
              });
            }
          );
        } else if (snapshot.hasError) {
          return Text("error: ${snapshot.error}");
        } else return CircularProgressIndicator();
      }
    );
  }
}