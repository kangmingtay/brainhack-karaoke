import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  void createOrUpdateKtvRoom(String ktvRoomId, ktvRoomMap) {
    Firestore.instance.collection('ktvRoom')
      .document(ktvRoomId).collection('songList')
      .add(ktvRoomMap).catchError((e){
        print(e.toString());
      });
  }

 Future<Stream<QuerySnapshot>> getSongList(String ktvRoomId) async {
    return await Firestore.instance.collection('ktvRoom')
    .document(ktvRoomId)
    .collection('songList')
    .orderBy('index')
    .snapshots();
  }
  
}