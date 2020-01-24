import 'package:flutter/material.dart';
import 'package:JapanK/datamodel.dart';
import 'searchbar.dart';
import 'navigationbar.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/newsitem.dart';

class HomePage extends StatelessWidget {
  HomePage() {
    //get local session token
    getSessionToken()
    .then((sessionToken) { 
      if (sessionToken != null) 
        mojiSessionToken = sessionToken;
      else changeSessionToken(mojiSessionToken);
     })
    .catchError((onError) { changeSessionToken(mojiSessionToken); });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Menu(context),
      appBar: NavigationBar(
        context, 
        actions: [
          SearchIcon()
        ],
      ),
      body: Column(
        children: <Widget>[
          SearchBar(),
          ListTile(
            title: Text(
              "一緒に　日本語を　勉強しましょう",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: NewsList())
        ],
      )
    );
  }
}