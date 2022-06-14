import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/custom_list_title.dart';
import 'package:my_mp3/helper/hexColor.dart';
import 'package:my_mp3/helper/music_helper.dart';
import 'package:my_mp3/model/audio_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class FavoritePage extends StatefulWidget {
  late AssetsAudioPlayer assetsAudioPlayer;
  FavoritePage({Key? key, required this.assetsAudioPlayer}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final musicController = Get.put(MusicController());

  final favorite = GetStorage();
  late AssetsAudioPlayer assetsAudioPlayer;
  late List<Audio> favoriteList;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = widget.assetsAudioPlayer;
  }

  void playListMusic(List<Audio> loopList, int index) async {
    await assetsAudioPlayer.open(Playlist(audios: loopList, startIndex: index),
        loopMode: LoopMode.playlist, autoStart: true, showNotification: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GradientText(
          'Favorite',
          style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          gradientType: GradientType.linear,
          gradientDirection: GradientDirection.ttb,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade900,
          ],
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          color: HexColor("#0E0E10"),
          child: Center(
            child: Column(children: [
              Expanded(
                  child: Obx(
                () => StreamBuilder<List<MusicSnapshot>>(
                  stream:
                      MusicSnapshot.getAllMusicOfList(musicController.loveList),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Lỗi xảy ra khi truy vấn dữ liệu"),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          "Đang tải dữ liệu....",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      favoriteList = fromMusicToAudio(snapshot.data!);
                      return snapshot.data!.isNotEmpty
                          ? ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) => customListTile(
                                    id: snapshot.data![index].music!.id,
                                    title: snapshot.data![index].music!.title,
                                    singer: snapshot.data![index].music!.singer,
                                    cover:
                                        snapshot.data![index].music!.coverUrl,
                                    onTap: () {
                                      musicController
                                          .updateLoopList(favoriteList);
                                      playListMusic(
                                          musicController.loopList
                                              .cast<Audio>(),
                                          index);
                                      musicController
                                          .updateFirstPlayStatus(true);
                                    },
                                  ))
                          : const Center(
                              child: Text(
                              "Không có bài hát yêu thích",
                              style: TextStyle(color: Colors.white),
                            ));
                    }
                  },
                ),
              )),
              Obx(() => musicController.firstPlay.value
                  ? const SizedBox(
                      height: 38,
                    )
                  : const SizedBox())
            ]),
          ),
        ),
      ),
    );
  }
}
