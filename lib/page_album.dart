import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/helper/hexColor.dart';
import 'package:my_mp3/model/album_model.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AlbumPage extends StatefulWidget {
  late AssetsAudioPlayer assetsAudioPlayer;
  AlbumPage({Key? key, required this.assetsAudioPlayer}) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final musicController = Get.put(MusicController());
  late AssetsAudioPlayer assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = widget.assetsAudioPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: GradientText(
          'Album',
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
      body: Container(
        color: HexColor("#0E0E10"),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<AlbumSnapshot>>(
              stream: AlbumSnapshot.getAllAlbum(),
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
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: .8,
                    padding: const EdgeInsets.all(10),
                    children: snapshot.data!
                        .map((albumSnap) => Container(
                              color: HexColor("#0E0E10"),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        'albumDetailPage',
                                        arguments: <String, dynamic>{
                                          'name': albumSnap.album!.name,
                                          'image': albumSnap.album!.image,
                                          'albumList':
                                              albumSnap.album!.albumList,
                                          'assetsAudioPlayer': assetsAudioPlayer
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 155.0,
                                      height: 150.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                albumSnap.album!.image),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    albumSnap.album!.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  );
                }
              },
            )),
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
