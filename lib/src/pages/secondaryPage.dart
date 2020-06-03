import 'package:flutter/material.dart';
import './navigationBar/destination.dart';

//for zhengwen to put search bar (just need to change the text here and link the page in ./pages/destinationView)

class SecondaryPage extends StatelessWidget {
  const SecondaryPage({ Key key, this.destination }) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: SizedBox.expand(
        child: InkWell(
          child: Center(
            //TODO change text
            child: Text('Secondary Page'),
          ),
        ),
      ),
    );
  }
}