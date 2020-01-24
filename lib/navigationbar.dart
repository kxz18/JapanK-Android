import 'package:JapanK/notespage.dart';
import 'package:flutter/material.dart';
import 'package:JapanK/global.dart';
import 'package:JapanK/settingspage.dart';
import 'collectionpage.dart';

class NavigationBar extends AppBar {
  NavigationBar(BuildContext context,
      {title = "japank", fontFactor = 2, actions})
      : super(
            title: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: fontFactor * STDFONTSIZE)),
            actions: actions);
}

class Menu extends Drawer {
  final BuildContext context;
  final bool onNotes;
  final bool onCollection;
  final bool onSettings;
  Menu(this.context,
      {this.onNotes = false,
      this.onCollection = false,
      this.onSettings = false})
      : super(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              accountEmail: Text("15068701650@163.com"),
              accountName: Text("local"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                while (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.speaker_notes),
              title: Text("Notes"),
              enabled: !onNotes,
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NotesPage())),
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("My Collection"),
              enabled: !onCollection,
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CollectionPage())),
            ),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                enabled: !onSettings,
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage())))
          ],
        ));
}
