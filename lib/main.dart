import 'package:flutter/material.dart';
import 'homepage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app',
      home: HomePage(),
    );
  }
}

void main() { 
  runApp(MyApp()); 
}