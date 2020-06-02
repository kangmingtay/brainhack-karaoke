import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//List of pages and its superficial properties
class Destination {
  const Destination(this.index, this.title, this.icon, this.color);
  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination(0, 'Home', Icons.home, Colors.teal),
  Destination(1, 'Secondary', Icons.business, Colors.cyan)
];