import 'package:agora_flutter_quickstart/src/pages/songconsole.dart';
import 'package:flutter/material.dart';
import './src/pages/homePage.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}