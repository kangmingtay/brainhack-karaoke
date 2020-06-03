import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  void createKtvRoom(String ktvRoomId, ktvRoomMap) {
    Firestore.instance.collection('ktvRoom')
      .document(ktvRoomId).setData(ktvRoomMap).catchError((e){
        print(e.toString());
      });
  }

 Future<Stream<QuerySnapshot>> getSongList(String ktvRoomId) async {
    return await Firestore.instance.collection('ktvRoom')
    .document(ktvRoomId)
    .collection('songList')
    .snapshots();
  }

  working() async {
    return await Firestore.instance.collection('ktvRoom')
    .getDocuments();
  }
}