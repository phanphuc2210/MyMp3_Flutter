import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:my_mp3/page_firebase_app.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/test_bottonBar.dart';

void main() {
  // AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
  //   return true;
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: MyFirebaseApp(),
      // home: BottomBar(),
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool firstPlay = false;

  final assetsAudioPlayer = AssetsAudioPlayer();

  void playMusic(String url, String title, String image, String artist) async {
    assetsAudioPlayer.open(
        Audio.network(url,
            metas: Metas(
                title: title,
                image: MetasImage.network(image),
                artist: artist)),
        autoStart: true,
        showNotification: true);
  }

  void playListMusic(int index) async {
    await assetsAudioPlayer.open(
        Playlist(audios: fromMusicToAudio(musicList), startIndex: index),
        loopMode: LoopMode.playlist,
        autoStart: true,
        showNotification: true);
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
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
              fontSize: 25.0,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            playListMusic(0);

            if (firstPlay == false) {
              setState(() {
                firstPlay = true;
              });
            }
          },
          child: const Icon(
            Icons.play_arrow,
            color: Colors.black,
          ),
          backgroundColor: Colors.blueAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        body: Center(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                padding: const EdgeInsets.only(top: 15),
                itemCount: musicList.length,
                itemBuilder: (context, index) => customListTile(
                    title: musicList[index].title,
                    singer: musicList[index].singer,
                    cover: musicList[index].coverUrl,
                    onTap: () {
                      playListMusic(index);

                      if (firstPlay == false) {
                        setState(() {
                          firstPlay = true;
                        });
                      }
                    }),
              )),
              firstPlay == false
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
                          child: StreamBuilder<Playing?>(
                            stream: assetsAudioPlayer.current,
                            builder: (context, playing) {
                              if (playing.data != null) {
                                final myAudio = find(
                                    fromMusicToAudio(musicList),
                                    playing.data!.audio.assetAudioPath);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            image: DecorationImage(
                                                image: NetworkImage(myAudio
                                                    .metas.image!.path)))),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            myAudio.metas.title!,
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
                                            myAudio.metas.artist!,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    PlayerBuilder.isPlaying(
                                        player: assetsAudioPlayer,
                                        builder: (context, isPlaying) {
                                          return IconButton(
                                              onPressed: () {
                                                assetsAudioPlayer.playOrPause();
                                              },
                                              icon: Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 40,
                                                color: Colors.white,
                                              ));
                                        })
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        )
                      ]),
                    ),
            ],
          ),
        ));
  }

  List<Audio> fromMusicToAudio(List<Music> musicList) {
    List<Audio> audios = [];
    for (var music in musicList) {
      Audio audio = Audio.network(music.url,
          metas: Metas(
              title: music.title,
              image: MetasImage.network(music.coverUrl),
              artist: music.singer));
      audios.add(audio);
    }

    return audios;
  }
}
*/
