import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/audio_model.dart';
import 'package:my_mp3/authentication/login_page.dart';
import 'package:my_mp3/custom_list_title.dart';
import 'package:my_mp3/helper/dialog.dart';
import 'package:my_mp3/helper/hexColor.dart';
import 'package:my_mp3/page_detail.dart';
import 'package:my_mp3/page_search.dart';
import 'package:my_mp3/player/PositionSeekWidget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _myPage = PageController(initialPage: 0);

  bool firstPlay = false;
  late List<Audio> musicList;

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
    await assetsAudioPlayer.open(Playlist(audios: musicList, startIndex: index),
        loopMode: LoopMode.playlist, autoStart: true, showNotification: true);
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  int? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _myPage.addListener(() {
      setState(() {
        _currentPage = _myPage.page!.toInt();
      });
    });
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
            InkWell(
              onTap: () {
                showSnackBar(context, "Signing out.....", 300);
                assetsAudioPlayer.dispose();
                FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                  showSnackBar(context, "Please sign in", 5);
                }).catchError((error) {
                  showSnackBar(context, "Sign out not successfully", 3);
                });
              },
              child: Container(
                color: HexColor("#0E0E10"),
                height: 40,
                child: const Center(
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.black,
          height: 77,
          child: Column(
            children: [
              const SizedBox(
                height: 29,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    iconSize: 30.0,
                    padding: const EdgeInsets.only(left: 28.0),
                    icon: Icon(
                      Icons.home,
                      color: _currentPage == 0 ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _myPage.jumpToPage(0);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    padding: const EdgeInsets.only(right: 28.0),
                    icon: Icon(
                      Icons.search,
                      color: _currentPage == 1 ? Colors.white : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _myPage.jumpToPage(1);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        elevation: 1,
        notchMargin: 5.0,
      ),

      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: [
          Center(
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
                            child: Text("Đang tải dữ liệu..."),
                          );
                        } else {
                          musicList = fromMusicToAudio(snapshot.data!);
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => customListTile(
                                title: snapshot.data![index].music!.title,
                                singer: snapshot.data![index].music!.singer,
                                cover: snapshot.data![index].music!.coverUrl,
                                onTap: () {
                                  playListMusic(index);

                                  if (firstPlay == false) {
                                    setState(() {
                                      firstPlay = true;
                                    });
                                  }
                                }),
                          );
                        }
                      },
                    ),
                  ),
                  firstPlay
                      ? const SizedBox(
                          height: 38,
                        )
                      : const SizedBox()
                ]),
              ),
            ),
          ),
          SearchPage(
            assetsAudioPlayer: assetsAudioPlayer,
            firstPlay: firstPlay,
          ),
        ],
      ),
      floatingActionButton: firstPlay == false
          ? const SizedBox()
          : InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPage(
                        assetsAudioPlayer: assetsAudioPlayer,
                        musicList: musicList)));
              },
              child: Container(
                height: 66,
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
                          detail: false,
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
                        bottom: 0.0, left: 12.0, right: 12.0),
                    child: StreamBuilder<Playing?>(
                      stream: assetsAudioPlayer.current,
                      builder: (context, playing) {
                        if (playing.data != null) {
                          final myAudio = find(
                              musicList, playing.data!.audio.assetAudioPath);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              myAudio.metas.image!.path)))),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: Colors.grey, fontSize: 14.0),
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
            ),

      // body: Container(
      //   color: HexColor("#0E0E10"),
      //   child: Center(
      //     child: Column(
      //       children: [
      //         Expanded(
      //           child: StreamBuilder<List<MusicSnapshot>>(
      //             stream: MusicSnapshot.getAllMusic(),
      //             builder: (context, snapshot) {
      //               if (snapshot.hasError) {
      //                 return const Center(
      //                   child: Text("Lỗi xảy ra khi truy vấn dữ liệu"),
      //                 );
      //               } else if (!snapshot.hasData) {
      //                 return const Center(
      //                   child: Text("Đang tải dữ liệu..."),
      //                 );
      //               } else {
      //                 musicList = fromMusicToAudio(snapshot.data!);
      //                 return ListView.builder(
      //                   itemCount: snapshot.data!.length,
      //                   itemBuilder: (context, index) => customListTile(
      //                       title: snapshot.data![index].music!.title,
      //                       singer: snapshot.data![index].music!.singer,
      //                       cover: snapshot.data![index].music!.coverUrl,
      //                       onTap: () {
      //                         playListMusic(index);

      //                         if (firstPlay == false) {
      //                           setState(() {
      //                             firstPlay = true;
      //                           });
      //                         }
      //                       }),
      //                 );
      //               }
      //             },
      //           ),
      //         ),
      //         firstPlay == false
      //             ? const SizedBox()
      //             : InkWell(
      //                 onTap: () {
      //                   Navigator.of(context).push(MaterialPageRoute(
      //                       builder: (context) => DetailPage(
      //                           assetsAudioPlayer: assetsAudioPlayer,
      //                           musicList: musicList)));
      //                 },
      //                 child: Container(
      //                   decoration: const BoxDecoration(
      //                       color: Colors.black,
      //                       boxShadow: [
      //                         BoxShadow(
      //                             color: Color(0x55212121), blurRadius: 8.0)
      //                       ]),
      //                   child: Column(children: [
      //                     assetsAudioPlayer.builderRealtimePlayingInfos(
      //                         builder: (context, RealtimePlayingInfos? infos) {
      //                       // if (infos == null) {
      //                       //   return SizedBox();
      //                       // }
      //                       //print('infos: $infos');
      //                       return Padding(
      //                         padding: const EdgeInsets.only(left: 8, right: 8),
      //                         child: Column(
      //                           children: [
      //                             PositionSeekWidget(
      //                               detail: false,
      //                               currentPosition: infos!.currentPosition,
      //                               duration: infos.duration,
      //                               seekTo: (to) {
      //                                 assetsAudioPlayer.seek(to);
      //                               },
      //                             ),
      //                           ],
      //                         ),
      //                       );
      //                     }),
      //                     Padding(
      //                       padding: const EdgeInsets.only(
      //                           bottom: 8.0, left: 12.0, right: 12.0),
      //                       child: StreamBuilder<Playing?>(
      //                         stream: assetsAudioPlayer.current,
      //                         builder: (context, playing) {
      //                           if (playing.data != null) {
      //                             final myAudio = find(musicList,
      //                                 playing.data!.audio.assetAudioPath);
      //                             return Row(
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceEvenly,
      //                               children: [
      //                                 Container(
      //                                     width: 50.0,
      //                                     height: 50.0,
      //                                     decoration: BoxDecoration(
      //                                         borderRadius:
      //                                             BorderRadius.circular(6.0),
      //                                         image: DecorationImage(
      //                                             image: NetworkImage(myAudio
      //                                                 .metas.image!.path)))),
      //                                 const SizedBox(
      //                                   width: 10.0,
      //                                 ),
      //                                 Expanded(
      //                                   child: Column(
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text(
      //                                         myAudio.metas.title!,
      //                                         overflow: TextOverflow.ellipsis,
      //                                         style: const TextStyle(
      //                                             fontSize: 15.0,
      //                                             fontWeight: FontWeight.w600,
      //                                             color: Colors.white),
      //                                       ),
      //                                       const SizedBox(
      //                                         height: 5.0,
      //                                       ),
      //                                       Text(
      //                                         myAudio.metas.artist!,
      //                                         style: const TextStyle(
      //                                             color: Colors.grey,
      //                                             fontSize: 14.0),
      //                                       )
      //                                     ],
      //                                   ),
      //                                 ),
      //                                 PlayerBuilder.isPlaying(
      //                                     player: assetsAudioPlayer,
      //                                     builder: (context, isPlaying) {
      //                                       return IconButton(
      //                                           onPressed: () {
      //                                             assetsAudioPlayer
      //                                                 .playOrPause();
      //                                           },
      //                                           icon: Icon(
      //                                             isPlaying
      //                                                 ? Icons.pause
      //                                                 : Icons.play_arrow,
      //                                             size: 40,
      //                                             color: Colors.white,
      //                                           ));
      //                                     })
      //                               ],
      //                             );
      //                           } else {
      //                             return const SizedBox();
      //                           }
      //                         },
      //                       ),
      //                     )
      //                   ]),
      //                 ),
      //               ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  List<Audio> fromMusicToAudio(List<MusicSnapshot> snapShot) {
    List<Audio> audios = [];
    for (var snap in snapShot) {
      Audio audio = Audio.network(snap.music!.url,
          metas: Metas(
              title: snap.music!.title,
              image: MetasImage.network(snap.music!.coverUrl),
              artist: snap.music!.singer));
      audios.add(audio);
    }

    return audios;
  }
}
