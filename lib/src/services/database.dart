import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  void createOrUpdateKtvRoom(String ktvRoomId, song) {
    Firestore.instance.collection('ktvRoom')
      .document(ktvRoomId)
      .setData({'songlist' : FieldValue.arrayUnion([song])}, merge: true);
  }

 Future<Stream<QuerySnapshot>> getSongList(String ktvRoomId) async {
    return await Firestore.instance.collection('ktvRoom')
    .document(ktvRoomId)
    .collection('songList')
    .orderBy('index')
    .snapshots();
  }
  
   Future<Stream<DocumentSnapshot>> getKtvRoom(String ktvRoomId) async {
    return await Firestore.instance.collection('ktvRoom')
    .document(ktvRoomId)
    .snapshots();
  }

  void deleteSong(String ktvRoomId, song) async {
    await Firestore.instance.collection('ktvRoom').document(ktvRoomId).updateData({
      'songlist' : FieldValue.arrayRemove([song])
    });
  }

  void insertSong(String ktvRoomId, song, songlist) async {
    await Firestore.instance.collection('ktvRoom')
      .document(ktvRoomId)
      .setData({'songlist' : FieldValue.arrayUnion([song] + songlist)}, merge: false);
  }
}