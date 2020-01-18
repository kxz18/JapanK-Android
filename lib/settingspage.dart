import 'package:flutter/material.dart';
import 'package:JapanK/datamodel.dart';
import 'package:JapanK/global.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          //session token update
          ListTile(
            leading: Icon(Icons.cached),
            title: Text("Moji Session Token"),
            subtitle: Text(mojiSessionToken),
            onTap: () {
              showInputDialog(
                context, 
                dealMethod: (onValue) {
                  if (onValue != false && onValue != null) {
                    changeSessionToken(onValue);
                    setState(() {
                      mojiSessionToken = onValue;
                    });
                  }
                },
                placeholder: mojiSessionToken
              );
            }
          )
        ],
      )
    );
  }
}

//input dialog with a text field
showInputDialog(BuildContext context, { Function(dynamic) dealMethod, String placeholder}) {
  String input = placeholder;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("Session Token"),
        contentPadding: EdgeInsets.all(20),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: input
            ),
            onChanged: (inputed) {
              input = inputed;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () { Navigator.pop(context, false); },
              ),
              SimpleDialogOption(
                child: Text("Confirm"),
                onPressed: () { Navigator.pop(context, input); },
              )
            ]
          )
        ],
      );
    }
  ).then(
    dealMethod);
}