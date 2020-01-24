import 'package:flutter/material.dart';
import 'homepage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app',
      home: HomePage(),
      theme: ThemeData.light(),
    );
  }
}

void main() {
  runApp(MyApp());
}
