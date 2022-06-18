import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_mp3/authentication/login_page.dart';
import 'package:my_mp3/helper/dialog.dart';
import 'package:my_mp3/helper/music_helper.dart';
import 'package:my_mp3/model/audio_model.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/custom_list_title.dart';
import 'package:my_mp3/helper/hexColor.dart';
import 'package:my_mp3/page_home.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AllMusicPage extends StatefulWidget {
  late AssetsAudioPlayer assetsAudioPlayer;
  AllMusicPage({Key? key, required this.assetsAudioPlayer}) : super(key: key);

  @override
  State<AllMusicPage> createState() => _AllMusicPageState();
}

class _AllMusicPageState extends State<AllMusicPage> {
  final musicController = Get.put(MusicController());
  final favorite = GetStorage();

  late AssetsAudioPlayer assetsAudioPlayer;
  late List<Audio> musicList;

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
          'MyMp3',
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
      drawer: Drawer(
        width: 250,
        backgroundColor: HexColor("#0E0E10"),
        child: Column(
          children: [
            const SizedBox(
              height: 40.0,
            ),
            GradientText(
              'MyMp3',
              style:
                  const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              gradientType: GradientType.linear,
              gradientDirection: GradientDirection.ttb,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade900,
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FirebaseAuth.instance.currentUser != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                image: DecorationImage(
                                    image: NetworkImage(FirebaseAuth
                                            .instance.currentUser!.photoURL ??
                                        "https://haycafe.vn/wp-content/uploads/2021/11/Anh-avatar-dep-chat-lam-hinh-dai-dien.jpg"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FirebaseAuth
                                          .instance.currentUser!.displayName ??
                                      FirebaseAuth.instance.currentUser!.email!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  FirebaseAuth.instance.currentUser!
                                              .displayName ==
                                          null
                                      ? ""
                                      : FirebaseAuth
                                          .instance.currentUser!.email!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            musicController.updateFirstPlayStatus(false);
                            musicController.updateCurrentSong("-999999");
                            assetsAudioPlayer.dispose();
                            FirebaseAuth.instance.signOut().whenComplete(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
                                  (route) => false);
                            }).catchError((error) {
                              showSnackBar(
                                  context, "Sign out not successfully", 3);
                            });
                          },
                          child: Container(
                            color: HexColor("#0E0E10"),
                            height: 40,
                            child: const Text(
                              "Sign out",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      musicController.updateFirstPlayStatus(false);
                      musicController.updateCurrentSong("-999999");
                      assetsAudioPlayer.dispose();
                      Get.to(() => const LoginPage());
                    },
                    child: Container(
                      color: HexColor("#0E0E10"),
                      height: 40,
                      child: const Center(
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: Center(
        child: Container(
          color: HexColor("#0E0E10"),
          child: Center(
            child: Column(children: [
              Expanded(
                child: StreamBuilder<List<MusicSnapshot>>(
                  stream: MusicSnapshot.getAllMusic(),
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
                      musicList = fromMusicToAudio(snapshot.data!);

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => customListTile(
                          id: snapshot.data![index].music!.id,
                          title: snapshot.data![index].music!.title,
                          singer: snapshot.data![index].music!.singer,
                          cover: snapshot.data![index].music!.coverUrl,
                          onTap: () {
                            musicController.updateLoopList(musicList);

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
