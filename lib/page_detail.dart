import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/helper/hexColor.dart';
import 'package:my_mp3/player/PlayingControls.dart';
import 'package:my_mp3/player/PositionSeekWidget.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  AssetsAudioPlayer assetsAudioPlayer;
  List<Audio> musicList;
  DetailPage(
      {Key? key, required this.assetsAudioPlayer, required this.musicList})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late AssetsAudioPlayer assetsAudioPlayer;
  late List<Audio> musicList;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = widget.assetsAudioPlayer;
    musicList = widget.musicList;
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: HexColor("#0E0E10"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30),
        color: HexColor("#0E0E10"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<Playing?>(
              stream: assetsAudioPlayer.current,
              builder: (context, playing) {
                if (playing.data != null) {
                  final myAudio =
                      find(musicList, playing.data!.audio.assetAudioPath);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        myAudio.metas.image!.path,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 45.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            myAudio.metas.title!,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            myAudio.metas.artist!,
                            style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            assetsAudioPlayer.builderCurrent(
                builder: ((context, Playing? playing) {
              return Column(
                children: [
                  assetsAudioPlayer.builderLoopMode(
                      builder: (context, loopMode) {
                    return PlayerBuilder.isPlaying(
                        player: assetsAudioPlayer,
                        builder: (context, isPlaying) {
                          return PlayingControls(
                            loopMode: loopMode,
                            // isPlaylist: true,
                            isPlaying: isPlaying,
                            onPlay: () {
                              assetsAudioPlayer.playOrPause();
                            },
                            toggleLoop: () {
                              assetsAudioPlayer.toggleLoop();
                            },
                            onNext: () {
                              assetsAudioPlayer.next(keepLoopMode: true);
                            },
                            onPrevious: () {
                              assetsAudioPlayer.previous(
                                  //keepLoopMode: false
                                  );
                            },
                          );
                        });
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  assetsAudioPlayer.builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? info) {
                    if (info == null) {
                      return const SizedBox();
                    }
                    return PositionSeekWidget(
                        detail: true,
                        currentPosition: info.currentPosition,
                        duration: info.duration,
                        seekTo: (to) {
                          assetsAudioPlayer.seek(to);
                        });
                  })
                ],
              );
            })),
          ],
        ),
      ),
    );
  }
}
