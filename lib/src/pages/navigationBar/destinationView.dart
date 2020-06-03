import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/src/pages/secondaryPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './destination.dart';
import './viewNavigatorObserver.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination, this.onNavigation})
      : super(key: key);

  final Destination destination;
  final VoidCallback onNavigation;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    //The main page
    if (widget.destination.title == 'Home') {
      return Navigator(
        observers: <NavigatorObserver>[
          ViewNavigatorObserver(widget.onNavigation),
        ],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return IndexPage();
            },
          );
        },
      );
    } else {
      //for search bar
      return Navigator(
        observers: <NavigatorObserver>[
          ViewNavigatorObserver(widget.onNavigation),
        ],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              //TODO change this part for search bar
              return SecondaryPage(destination: widget.destination);
            },
          );
        },
      );
    }
  }
}
