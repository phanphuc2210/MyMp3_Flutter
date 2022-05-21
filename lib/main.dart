import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:my_mp3/player/PositionSeekWidget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/audio_model.dart';
import 'package:my_mp3/custom_list_title.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  IconData btnIcon = Icons.play_arrow;

  final assetsAudioPlayer = AssetsAudioPlayer();

  // bool isPlaying = false;
  String currentSong = "";

  void playMusic(String url, String title, String image, String artist) async {
    // if (isPlaying && currentSong != url) {

    //   assetsAudioPlayer.open(
    //       Audio(url,
    //           metas: Metas(
    //               title: title,
    //               image: MetasImage.network(image),
    //               artist: artist)),
    //       autoStart: true,
    //       showNotification: true);

    // } else if (!isPlaying) {
    //   // int result = await audioPlayer.play(url);
    //   assetsAudioPlayer.open(
    //       Audio(url,
    //           metas: Metas(
    //               title: title,
    //               image: MetasImage.network(image),
    //               artist: artist)),
    //       autoStart: true,
    //       showNotification: true);
    //   // if (result == 1) {
    //   setState(() {
    //     isPlaying = true;
    //     btnIcon = Icons.pause;
    //   });
    //   // }
    // }

    assetsAudioPlayer.open(
        Audio(url,
            metas: Metas(
                title: title,
                image: MetasImage.network(image),
                artist: artist)),
        autoStart: true,
        showNotification: true);

    if (!assetsAudioPlayer.isPlaying.value) {
      setState(() {
        btnIcon = Icons.pause;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: GradientText(
            'My Playlist',
            style: const TextStyle(
              fontSize: 28.0,
            ),
            gradientType: GradientType.linear,
            gradientDirection: GradientDirection.ttb,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade900,
            ],
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: musicList.length,
              itemBuilder: (context, index) => customListTile(
                  title: musicList[index].title,
                  singer: musicList[index].singer,
                  cover: musicList[index].coverUrl,
                  onTap: () {
                    playMusic(musicList[index].url, musicList[index].title,
                        musicList[index].coverUrl, musicList[index].singer);
                    setState(() {
                      currentTitle = musicList[index].title;
                      currentCover = musicList[index].coverUrl;
                      currentSinger = musicList[index].singer;
                      currentSong = musicList[index].url;
                    });
                  }),
            )),
            currentTitle == ""
                ? SizedBox()
                : Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(color: Color(0x55212121), blurRadius: 8.0)
                        ]),
                    child: Column(children: [
                      assetsAudioPlayer.builderRealtimePlayingInfos(
                          builder: (context, RealtimePlayingInfos? infos) {
                        // if (infos == null) {
                        //   return SizedBox();
                        // }
                        //print('infos: $infos');
                        return Column(
                          children: [
                            PositionSeekWidget(
                              currentPosition: infos!.currentPosition,
                              duration: infos.duration,
                              seekTo: (to) {
                                assetsAudioPlayer.seek(to);
                              },
                            ),
                          ],
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 12.0, right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    image: DecorationImage(
                                        image: NetworkImage(currentCover)))),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentTitle,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    currentSinger,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14.0),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                btnIcon,
                                color: Colors.white,
                              ),
                              iconSize: 42.0,
                              onPressed: () {
                                if (assetsAudioPlayer.isPlaying.value) {
                                  // audioPlayer.pause();
                                  assetsAudioPlayer.pause();
                                  setState(() {
                                    btnIcon = Icons.play_arrow;
                                    // isPlaying = false;
                                  });
                                } else {
                                  // audioPlayer.resume();
                                  assetsAudioPlayer.play();
                                  setState(() {
                                    btnIcon = Icons.pause;
                                    // isPlaying = true;
                                  });
                                }
                              },
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
          ],
        ));
  }
}
