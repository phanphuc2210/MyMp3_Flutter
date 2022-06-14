import 'package:cloud_firestore/cloud_firestore.dart';

class Music {
  late String id;
  late String title;
  late String singer;
  late String url;
  late String coverUrl;
  late String lyric;

  Music(
      {required this.id,
      required this.title,
      required this.singer,
      required this.url,
      required this.coverUrl,
      required this.lyric});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
        id: json["id"] as String,
        title: json["title"] as String,
        singer: json["singer"] as String,
        url: json["url"] as String,
        coverUrl: json["coverUrl"] as String,
        lyric: json["lyric"] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "singer": singer,
      "url": url,
      "coverUrl": coverUrl,
      "lyric": lyric
    };
  }
}

class MusicSnapshot {
  Music? music;
  DocumentReference? docRef;

  MusicSnapshot({required this.music, required this.docRef});

  factory MusicSnapshot.fromSnapshot(DocumentSnapshot docSnap) {
    return MusicSnapshot(
      music: Music.fromJson(docSnap.data() as Map<String, dynamic>),
      docRef: docSnap.reference,
    );
  }

  static Stream<List<MusicSnapshot>> getAllMusic() {
    Stream<QuerySnapshot> qs =
        FirebaseFirestore.instance.collection("Music").snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qsnap) => qsnap.docs);

    return listDocSnap.map((lds) =>
        lds.map((docSnap) => MusicSnapshot.fromSnapshot(docSnap)).toList());
  }

  static Stream<List<MusicSnapshot>> getAllMusicOfSinger(String singer) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Music")
        .where("singer", isEqualTo: singer)
        .snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qsnap) => qsnap.docs);

    return listDocSnap.map((lds) =>
        lds.map((docSnap) => MusicSnapshot.fromSnapshot(docSnap)).toList());
  }

  static Stream<List<MusicSnapshot>> getAllMusicOfList(List albumList) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Music")
        .where("id", whereIn: albumList)
        .snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qsnap) => qsnap.docs);

    return listDocSnap.map((lds) =>
        lds.map((docSnap) => MusicSnapshot.fromSnapshot(docSnap)).toList());
  }
}
