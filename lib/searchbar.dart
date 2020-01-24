import 'package:flutter/material.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/utils.dart';
import 'searchresultpage.dart';
import 'package:JapanK/datamodel.dart';
import 'package:JapanK/worditem.dart';

class SearchIcon extends StatelessWidget {
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.search),
        tooltip: "Search",
        onPressed: () {
          showSearch(context: context, delegate: SearchBarDelegate());
        });
  }
}

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey.withAlpha(50),
                width: 2,
                style: BorderStyle.solid)),
        child: TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.translate),
              labelText: "Tap to Search",
              border: InputBorder.none,
            ),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.left,
            onTap: () {
              showSearch(context: context, delegate: SearchBarDelegate());
            },
            onChanged: (tappedInfo) {
              showSearch(context: context, delegate: SearchBarDelegate());
            }));
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  String curId;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      //clear button
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ""),
      //search button
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => showResults(context),
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    if (this.curId == null)
      return Center(
          child: Text(
        "No result found",
        style: TextStyle(fontSize: 1.5 * STDFONTSIZE),
      ));
    return Container(child: SearchResultPage(id: this.curId));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<List> futureSuggestionList = fetchSuggestionList(this.query);
    return FutureBuilder<List>(
        future: futureSuggestionList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List suggestionList = snapshot.data;
            if (suggestionList.length != 0) {
              this.curId = suggestionList[0].id;
              return ListView.builder(
                  itemCount: suggestionList.length,
                  itemBuilder: (context, index) => WordItem(
                        word: suggestionList[index],
                        onTap: () {
                          this.query = suggestionList[index].spell;
                          if (suggestionList.length != 0)
                            this.curId = suggestionList[index].id;
                          else
                            this.curId = null;
                          showResults(context);
                        },
                      ));
            } else
              return Center(child: Text("No result found"));
          } else if (snapshot.hasError) {
            return ErrorHandler(error: snapshot.error);
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
