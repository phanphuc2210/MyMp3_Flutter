import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/helper/music_helper.dart';
import 'package:my_mp3/page_album.dart';
import 'package:my_mp3/page_album_detail.dart';
import 'package:my_mp3/page_all_music.dart';
import 'package:my_mp3/page_detail.dart';
import 'package:my_mp3/page_favorite.dart';
import 'package:my_mp3/page_search.dart';
import 'package:my_mp3/page_singer.dart';
import 'package:my_mp3/page_singer_detail.dart';
import 'package:my_mp3/player/PositionSeekWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final musicController = Get.put(MusicController());
  final favorite = GetStorage();

  final PageController _myPage = PageController(initialPage: 0);

  final assetsAudioPlayer = AssetsAudioPlayer();

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
  void dispose() {
    super.dispose();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.music_note,
                        color: _currentPage == 2 ? Colors.white : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(2);
                        });
                      },
                    ),
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.album,
                        color: _currentPage == 3 ? Colors.white : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(3);
                        });
                      },
                    ),
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.favorite,
                        color: _currentPage == 4 ? Colors.white : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(4);
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
            AllMusicPage(assetsAudioPlayer: assetsAudioPlayer),
            SearchPage(
              assetsAudioPlayer: assetsAudioPlayer,
            ),
            // SingerPage(
            //   assetsAudioPlayer: assetsAudioPlayer,
            // ),
            // Trang danh sách ca sĩ
            Navigator(
              onGenerateRoute: (settings) {
                Widget page = SingerPage(
                  assetsAudioPlayer: assetsAudioPlayer,
                );
                if (settings.name == 'singerDetailPage') {
                  Map arg = settings.arguments! as Map;
                  page = SingerDetailPage(
                    name: arg['name'],
                    avatar: arg['avatar'],
                    assetsAudioPlayer: arg['assetsAudioPlayer'],
                  );
                }
                return MaterialPageRoute(builder: (_) => page);
              },
            ),
            // Trang danh sách Album
            Navigator(
              onGenerateRoute: (settings) {
                Widget page = AlbumPage(
                  assetsAudioPlayer: assetsAudioPlayer,
                );
                if (settings.name == 'albumDetailPage') {
                  Map arg = settings.arguments! as Map;
                  page = AlbumDetailPage(
                    name: arg['name'],
                    image: arg['image'],
                    albumList: arg['albumList'],
                    assetsAudioPlayer: arg['assetsAudioPlayer'],
                  );
                }
                return MaterialPageRoute(builder: (_) => page);
              },
            ),
            FavoritePage(assetsAudioPlayer: assetsAudioPlayer)
          ],
          physics: const NeverScrollableScrollPhysics(),
        ),
        floatingActionButton: Obx(
          () => musicController.firstPlay.isFalse
              ? const SizedBox()
              : InkWell(
                  onTap: () {
                    Get.to(
                        () => DetailPage(
                            assetsAudioPlayer: assetsAudioPlayer,
                            musicList: musicController.loopList.cast<Audio>()),
                        transition: Transition.downToUp);
                  },
                  child: Container(
                    height: 66,
                    width: double.infinity,
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
                                  musicController.loopList.cast<Audio>(),
                                  playing.data!.audio.assetAudioPath);

                              // Cập nhật lại bài hát đang phát
                              // tránh lỗi setState() or markNeedBuild called during build
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                musicController
                                    .updateCurrentSong(myAudio.metas.id!);
                              });

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
                                              image: NetworkImage(
                                                  myAudio.metas.image!.path)))),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 9.0),
                                    child: InkWell(
                                        onTap: () {
                                          if (musicController.loveList
                                              .contains(myAudio.metas.id!)) {
                                            musicController.loveList
                                                .remove(myAudio.metas.id!);
                                          } else {
                                            musicController.loveList
                                                .add(myAudio.metas.id!);
                                          }

                                          favorite.write("favoriteList",
                                              musicController.loveList);
                                        },
                                        child: Obx(() => musicController
                                                .loveList
                                                .contains(myAudio.metas.id!)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.blue.shade900,
                                                size: 28,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline,
                                                color: Colors.white,
                                                size: 28,
                                              ))),
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
        ));
  }
}
