import 'package:flutter/material.dart';
import 'package:JapanK/datamodel.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/wordcard.dart';
import 'package:JapanK/star.dart';

class WordItem extends ListTile {
  final word;
  final Key key;
  WordItem({this.key, @required this.word, onTap})
      : super(
            title: Text(word.spell + " | " + word.kana + word.accent),
            subtitle: Text(word.excerpt),
            trailing: Star(word.id),
            onTap: onTap);
}

Widget wordlistBuilder(Set<String> ids) {
  List<Widget> allWords = [];
  if (ids.length == 0)
    return Center(
        child: Text(
      "No content",
      style: TextStyle(fontSize: 1.5 * STDFONTSIZE, color: Colors.grey),
    ));
  for (String id in ids) {
    allWords.add(FutureBuilder<Post>(
        future: fetchPost(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WordItem(
                key: Key(snapshot.data.id),
                word: snapshot.data,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Scaffold(
                            appBar: AppBar(),
                            body: WordCard(wordInfo: snapshot.data),
                          )));
                });
          } else
            return Container();
        }));
  }
  return Column(children: allWords);
}
