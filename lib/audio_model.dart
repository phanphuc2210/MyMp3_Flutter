import 'package:cloud_firestore/cloud_firestore.dart';

class Music {
  late String title;
  late String singer;
  late String url;
  late String coverUrl;

  Music(
      {required this.title,
      required this.singer,
      required this.url,
      required this.coverUrl});

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json["title"] as String,
      singer: json["singer"] as String,
      url: json["url"] as String,
      coverUrl: json["coverUrl"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "singer": singer,
      "url": url,
      "coverUrl": coverUrl,
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
}

List<Music> musicList = [
  Music(
      title: "Nếu anh thấy lòng mình yếu đuối",
      singer: "Tùa, CM1X",
      url:
          "https://tainhac123.com/listen/neu-anh-thay-long-minh-yeu-duoi-tua-ft-cm1x.VMIbTHLJvLIE.html",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w480_r1x1_webp/avatars/9/6/6/1/9661a29d6ff686f16100bd4bd56db877.jpg"),
  Music(
      title: "To The Moon",
      singer: "hooligan",
      // url: "asset/audios/ToTheMoon.mp3",
      url:
          "https://tainhac123.com/listen/to-the-moon-hooligan.zO62A4FQmH79.html",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w480_r1x1_webp/cover/e/5/1/c/e51c451a2718ba4e38569b00a57be29f.jpg"),
  Music(
      title: "Chạy Về Nơi Phía Anh",
      singer: "Khắc Việt",
      // url: "asset/audios/ChayVeNoiPhiaAnh.mp3",
      url:
          "https://tainhac123.com/listen/chay-ve-noi-phia-anh-khac-viet.K50N4xtWe5y4.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2022/02/10/2/a/7/7/1644475457323.jpg"),
  Music(
      title: "Có Hẹn Với Thanh Xuân",
      singer: "MONSTAR",
      // url: "asset/audios/cohenvoithanhxuan.mp3",
      url:
          "https://tainhac123.com/listen/co-hen-voi-thanh-xuan-monstar.B1Q3wlGhldTr.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2021/07/16/f/4/9/8/1626425507034.jpg"),
  Music(
      title: "Thức Giấc",
      singer: "Da LAB",
      // url: "asset/audios/ThucGiac.mp3",
      url: "https://tainhac123.com/listen/thuc-giac-da-lab.uyQTq9aL9Nfr.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2021/07/14/8/c/f/9/1626231010810.jpg"),
  Music(
      title: "Paper Cuts",
      singer: "EXO",
      // url: "asset/audios/ThucGiac.mp3",
      url: "https://tainhac123.com/listen/paper-cuts-exo.eMBXMnZv1mcr.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/singer/avatar/2018/08/28/9/d/1/c/1535431732007.jpg"),
  Music(
      title: "Cứ Thở Đi",
      singer: "Đức Phúc, Juky San",
      // url: "asset/audios/ThucGiac.mp3",
      url:
          "https://tainhac123.com/listen/cu-tho-di-duc-phuc-ft-juky-san.W9fxPEs6LPJc.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2022/05/09/5/a/4/f/1652084366670.jpg"),
  Music(
      title: "Tháng Mấy Em Nhớ Anh?",
      singer: "Hà Anh Tuấn",
      // url: "asset/audios/ThucGiac.mp3",
      url:
          "https://tainhac123.com/listen/thang-may-em-nho-anh-ha-anh-tuan.tV4swZ9ekyZS.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2021/04/01/e/2/b/5/1617248289520.jpg"),
  Music(
      title: "Rung Động",
      singer: "Dương Edward",
      // url: "asset/audios/ThucGiac.mp3",
      url: "https://tainhacmienphi.biz/get/song/api/370785",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_webp/cover/d/e/3/8/de38ea78ded4ceaf57bd74b07125bcef.jpg"),
  Music(
      title: "Dù Cho Mai Về Sau",
      singer: "buitruonglinh",
      // url: "asset/audios/ThucGiac.mp3",
      url: "https://tainhacmienphi.biz/get/song/api/247845",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_webp/cover/0/8/5/0/0850b7d79b732fd99e3383909f807d58.jpg"),
  Music(
      title: "Gác Lại Âu Lo",
      singer: "Da LAB, Miu Lê",
      // url: "asset/audios/ThucGiac.mp3",
      url: "https://tainhacmienphi.biz/get/song/api/173028",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_webp/cover/d/5/8/a/d58aa48a38c0a8dc89c95277b456bc75.jpg"),
  Music(
      title: "Hẹn Ước Từ Hư Vô",
      singer: "My Tam",
      // url: "asset/audios/ThucGiac.mp3",
      url: "https://tainhacmienphi.biz/get/song/api/366833",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_webp/avatars/a/3/a3b8a090fa8e0b4e4ac7d4f028022a87_1460105189.jpg"),
];
