import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/custom_list_title.dart';
import 'package:my_mp3/helper/hexColor.dart';
import 'package:my_mp3/helper/music_helper.dart';
import 'package:my_mp3/model/audio_model.dart';

class AlbumDetailPage extends StatefulWidget {
  late String name;
  late String image;
  late List albumList;
  late AssetsAudioPlayer assetsAudioPlayer;
  AlbumDetailPage(
      {Key? key,
      required this.name,
      required this.image,
      required this.albumList,
      required this.assetsAudioPlayer})
      : super(key: key);

  @override
  State<AlbumDetailPage> createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  final musicController = Get.put(MusicController());
  final favorite = GetStorage();

  late String name;
  late String image;
  late List albumList;
  late AssetsAudioPlayer assetsAudioPlayer;

  List<Audio> albumAudioList = [];

  @override
  void initState() {
    super.initState();
    name = widget.name;
    image = widget.image;
    albumList = widget.albumList;
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
        title: const Text(""),
        backgroundColor: HexColor("#0E0E10"),
        elevation: 0,
      ),
      backgroundColor: HexColor("#0E0E10"),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 155.0,
              height: 150.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.fill),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<List<MusicSnapshot>>(
                stream: MusicSnapshot.getAllMusicOfList(albumList),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Lỗi xảy ra khi truy vấn dữ liệu"),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        "Đang tải dữ liệu...",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    albumAudioList = fromMusicToAudio(snapshot.data!);
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => customListTile(
                        id: snapshot.data![index].music!.id,
                        title: snapshot.data![index].music!.title,
                        singer: snapshot.data![index].music!.singer,
                        cover: snapshot.data![index].music!.coverUrl,
                        onTap: () {
                          musicController.updateLoopList(albumAudioList);

                          playListMusic(
                              musicController.loopList.cast<Audio>(), index);
                          musicController.updateFirstPlayStatus(true);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Obx(() => musicController.firstPlay.isTrue
                ? const SizedBox(
                    height: 38,
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}
