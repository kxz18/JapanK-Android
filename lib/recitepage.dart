import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:JapanK/datamodel.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/searchresultpage.dart';

class RecitePage extends StatefulWidget {
  RecitePage({@required this.ids});
  final Set<String> ids;
  @override
  _RecitePageState createState() => _RecitePageState(ids: this.ids);
}

class _RecitePageState extends State<RecitePage> {
  _RecitePageState({@required this.ids});
  Set<String> ids;
  List<String> shuffledIds;
  int curIndex;

  @override
  void initState() {
    super.initState();
    shuffledIds = ids.toList();
    shuffledIds.shuffle();
    curIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) =>     //covered by Builder to provide snackbar
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      if (this.curIndex > 0) 
                        setState(() => this.curIndex--);
                      else Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Already the first one!"))
                      );
                    },
                  )
                ),
                Flexible(
                  flex: 6,
                  child: shuffledIds.length == 0 ? 
                    Text(
                      "No word in collection",
                      style: TextStyle(
                        fontSize: 1.5*STDFONTSIZE
                      ),
                    )
                  : ReciteWordCard(wordId: shuffledIds[curIndex]),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      if (this.curIndex < ids.length-1)
                        setState(() { this.curIndex++;});
                      else Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Reached the last one!"),)
                      );
                    },
                  )
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  (ids.length == 0 ? 0 : curIndex+1).toString() + 
                  " / " + ids.length.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: STDFONTSIZE,
                  ),
                )
              ],
            )
        ])
      )
    );
  }
}

class ReciteWordCard extends StatelessWidget {
  ReciteWordCard({@required this.wordId});
  final String wordId;
  @override
  Widget build(BuildContext context) {
    print(wordId);
    return FutureBuilder<Post> (
      future: fetchPost(wordId),
      builder: (context, snapshot) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return GestureDetector(
          onTap: () {
            if (snapshot.hasData) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: SearchResultPage(id: wordId),
                  );
                }
              ));
            }
          },
          child: Card(
            child: Container(
              margin: EdgeInsets.all(2*STDFONTSIZE),
              height: height*0.6,
              width: width*0.7,
              child: Builder(
                builder: (context) {
                  if (snapshot.hasData) {
                    Post word = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          word.spell,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 2.5*STDFONTSIZE
                          )
                        ),
                        Text(
                          word.kana + word.accent,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: height*0.2,),
                        Text(
                          "Tap to see defination",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    removeCollection(wordId);
                    return Text("An error occurred : ${snapshot.error}, please ignore this word, word id: $wordId");
                  } else return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          )
        );
      },
    );
  }
}