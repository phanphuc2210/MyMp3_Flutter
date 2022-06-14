import 'package:cloud_firestore/cloud_firestore.dart';

class Singer {
  late String name;
  late String avatar;

  Singer({required this.name, required this.avatar});

  factory Singer.fromJson(Map<String, dynamic> json) {
    return Singer(
        name: json["name"] as String, avatar: json["avatar"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "avatar": avatar,
    };
  }
}

class SingerSnapshot {
  Singer? singer;
  DocumentReference? docRef;

  SingerSnapshot({required this.singer, required this.docRef});

  factory SingerSnapshot.fromSnapshot(DocumentSnapshot docSnap) {
    return SingerSnapshot(
      singer: Singer.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  static Stream<List<SingerSnapshot>> getAllSinger() {
    Stream<QuerySnapshot> qs =
        FirebaseFirestore.instance.collection("Singer").snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qsnap) => qsnap.docs);

    return listDocSnap.map((lds) =>
        lds.map((docSnap) => SingerSnapshot.fromSnapshot(docSnap)).toList());
  }
}
