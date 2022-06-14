import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Album {
  late String name;
  late String image;
  late List albumList;

  Album({required this.name, required this.image, required this.albumList});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        name: json["name"] as String,
        image: json["image"] as String,
        albumList: json["albumList"] as List);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
      "albumList": albumList,
    };
  }
}

class AlbumSnapshot {
  Album? album;
  DocumentReference? docRef;

  AlbumSnapshot({this.album, this.docRef});

  factory AlbumSnapshot.fromSnapshot(DocumentSnapshot docSnap) {
    return AlbumSnapshot(
      album: Album.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  static Stream<List<AlbumSnapshot>> getAllAlbum() {
    Stream<QuerySnapshot> qs =
        FirebaseFirestore.instance.collection("Album").snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qsnap) => qsnap.docs);

    return listDocSnap.map((lds) =>
        lds.map((docSnap) => AlbumSnapshot.fromSnapshot(docSnap)).toList());
  }
}
