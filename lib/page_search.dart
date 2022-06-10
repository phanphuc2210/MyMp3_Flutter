import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_mp3/audio_model.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/custom_list_title.dart';
import 'package:my_mp3/helper/hexColor.dart';

class SearchPage extends StatefulWidget {
  late AssetsAudioPlayer assetsAudioPlayer;

  SearchPage({Key? key, required this.assetsAudioPlayer}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final musicController = Get.put(MusicController());
  TextEditingController txtSearch = TextEditingController();
  late AssetsAudioPlayer assetsAudioPlayer;

  late Future resultsLoaded;
  List allResults = [];
  List<MusicSnapshot> resultsList = [];
  List<Audio> audioList = [];

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = widget.assetsAudioPlayer;

    txtSearch.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    super.dispose();
    txtSearch.removeListener(_onSearchChanged);
    txtSearch.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getMusicStreamSnapshot();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    List<MusicSnapshot> showResults = [];

    if (txtSearch.text != "") {
      for (var musicSnap in allResults) {
        var title =
            MusicSnapshot.fromSnapshot(musicSnap).music!.title.toLowerCase();

        if (title.contains(txtSearch.text.toLowerCase())) {
          showResults.add(MusicSnapshot.fromSnapshot(musicSnap));
        }
      }
    }
    setState(() {
      resultsList = showResults;
      audioList = fromMusicToAudio(resultsList);
    });
  }

  getMusicStreamSnapshot() async {
    var data = await FirebaseFirestore.instance.collection("Music").get();
    setState(() {
      allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  void playListMusic(List<Audio> loopList, int index) async {
    await assetsAudioPlayer.open(Playlist(audios: loopList, startIndex: index),
        loopMode: LoopMode.playlist, autoStart: true, showNotification: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: HexColor("#0E0E10"),
        padding: EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 38),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Search",
            //   style: TextStyle(
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white),
            // ),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.0),
              ),
              height: 45.0,
              child: TextFormField(
                controller: txtSearch,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 12.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: resultsList.length,
                    itemBuilder: (context, index) => customListTile(
                        title: resultsList[index].music!.title,
                        singer: resultsList[index].music!.singer,
                        cover: resultsList[index].music!.coverUrl,
                        onTap: () {
                          musicController.updateLoopList(audioList);
                          playListMusic(
                              musicController.loopList.cast<Audio>(), index);
                          musicController.updateFirstPlayStatus(true);
                        })))
          ],
        ),
      ),
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

// Widget SearchPage() {
//   TextEditingController txtEmail = TextEditingController();
//   return Container(
//     color: HexColor("#0E0E10"),
//     padding: EdgeInsets.only(top: 8, left: 14, right: 14, bottom: 38),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           "Search",
//           style: TextStyle(
//               fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
//         ),

//       ],
//     ),
//   );
// }
