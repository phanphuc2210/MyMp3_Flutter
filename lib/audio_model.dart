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
}

List<Music> musicList = [
  Music(
      title: "Nếu anh thấy lòng mình yếu đuối",
      singer: "Tùa, CM1X",
      url: "asset/audios/test.mp3",
      // url:
      //     "https://tainhac123.com/listen/yeu-duong-kho-qua-thi-chay-ve-khoc-voi-anh-erik.B6rEC4ZEO7oD.html",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w480_r1x1_webp/avatars/9/6/6/1/9661a29d6ff686f16100bd4bd56db877.jpg"),
  Music(
      title: "To The Moon",
      singer: "hooligan",
      url: "asset/audios/ToTheMoon.mp3",
      // url:
      //     "https://tainhac123.com/listen/yeu-duong-kho-qua-thi-chay-ve-khoc-voi-anh-erik.B6rEC4ZEO7oD.html",
      coverUrl:
          "https://photo-resize-zmp3.zmdcdn.me/w480_r1x1_webp/cover/e/5/1/c/e51c451a2718ba4e38569b00a57be29f.jpg"),
  Music(
      title: "Chạy Về Nơi Phía Anh",
      singer: "Khắc Việt",
      url: "asset/audios/ChayVeNoiPhiaAnh.mp3",
      // url:
      //     "https://tainhac123.com/listen/yeu-duong-kho-qua-thi-chay-ve-khoc-voi-anh-erik.B6rEC4ZEO7oD.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2022/02/10/2/a/7/7/1644475457323.jpg"),
  Music(
      title: "Có Hẹn Với Thanh Xuân",
      singer: "MONSTAR",
      url: "asset/audios/cohenvoithanhxuan.mp3",
      // url:
      //     "https://tainhac123.com/listen/yeu-duong-kho-qua-thi-chay-ve-khoc-voi-anh-erik.B6rEC4ZEO7oD.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2021/07/16/f/4/9/8/1626425507034.jpg"),
  Music(
      title: "Thức Giấc",
      singer: "Da LAB",
      url: "asset/audios/ThucGiac.mp3",
      // url:
      //     "https://tainhac123.com/listen/yeu-duong-kho-qua-thi-chay-ve-khoc-voi-anh-erik.B6rEC4ZEO7oD.html",
      coverUrl:
          "https://avatar-nct.nixcdn.com/song/2021/07/14/8/c/f/9/1626231010810.jpg"),
];
