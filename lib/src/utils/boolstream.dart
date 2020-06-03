import 'dart:async';

class BooleanStream {

  // The controller to stream the final output to the required StreamBuilder
  final _boolean = StreamController<bool>.broadcast();
  Stream<bool> get boolean => _boolean.stream;

  // The controller to receive the input form the app elements     
  final _query = StreamController<bool>();
  Sink<bool> get query => _query.sink;
  Stream<bool> get result => _query.stream;

  // The business logic
  BooleanStream() {
    result.listen((value) {     // Listen for incoming input         
      _boolean.add(value);         // Stream the required output
    });
  }

  void dispose(){
    _query.close();
    _boolean.close();
  }
}