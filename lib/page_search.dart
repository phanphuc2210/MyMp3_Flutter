import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/audio_model.dart';
import 'package:my_mp3/custom_list_title.dart';
import 'package:my_mp3/helper/hexColor.dart';

class SearchPage extends StatefulWidget {
  late AssetsAudioPlayer assetsAudioPlayer;
  late bool firstPlay;
  SearchPage(
      {Key? key, required this.assetsAudioPlayer, required this.firstPlay})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController txtSearch = TextEditingController();
  late AssetsAudioPlayer assetsAudioPlayer;
  late bool firstPlay;

  late Future resultsLoaded;
  List allResults = [];
  List<MusicSnapshot> resultsList = [];

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = widget.assetsAudioPlayer;
    firstPlay = widget.firstPlay;
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
                    hintText: "Enter song",
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
                          playMusic(
                              resultsList[index].music!.url,
                              resultsList[index].music!.title,
                              resultsList[index].music!.coverUrl,
                              resultsList[index].music!.singer);
                          if (firstPlay == false) {
                            setState(() {
                              firstPlay = true;
                            });
                          }
                        })))
          ],
        ),
      ),
    );
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
