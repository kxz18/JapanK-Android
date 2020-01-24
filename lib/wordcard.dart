import 'package:JapanK/noteicon.dart';
import 'package:flutter/material.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/datamodel.dart';
import 'package:JapanK/star.dart';

class WordCard extends StatelessWidget {
  WordCard({this.wordInfo});
  final Post wordInfo;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              flex: 3,
              child:
                Text(
                  wordInfo.spell,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 2*STDFONTSIZE,
                  )
                )
            ),
            Flexible(child: Star(wordInfo.id)),
            Flexible(child: NoteIcon(wordInfo.id))
          ]
        ),
        Text(
          wordInfo.kana + wordInfo.accent,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: STDFONTSIZE,
          ),
        ),
        detailSection()
      ],
    );
  }

  //detail section builder
  Widget detailSection() {
    List<Widget> details = [];
    for (var item in wordInfo.details) {
      details.add(Column(
        children: [
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 1.2*STDFONTSIZE,
          ),
        ),
        Divider(),
        subdetailSection(item.subdetails)
      ]));
    }
    return Column(children: details);
  }

  Widget subdetailSection(List<SubDetail> subdetailsOrigin) {
    List <Widget> subdetails = [];
    int order = 0;
    for (var item in subdetailsOrigin) {
      order++;
      subdetails.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              order.toString() + ". " + item.title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: STDFONTSIZE
              ),
            )
          ),
          exampleSection(item.examples)
      ]));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subdetails
    );
  }

  Widget exampleSection(List<Example> examplesOrigin) {
    List<Widget> examples = [];
    for (var item in examplesOrigin) {
      examples.add(ListTile(
        title: Text(item.title),
        subtitle: Text(item.trans),
      ));
    }
    return Column(children: examples);
  }
}