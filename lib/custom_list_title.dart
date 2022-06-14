import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_mp3/controller/music_controller.dart';
import 'package:my_mp3/helper/hexColor.dart';

Widget customListTile({
  required String id,
  required String title,
  required String singer,
  required String cover,
  onTap,
}) {
  final musicController = Get.put(MusicController());
  final favorite = GetStorage();
  return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: HexColor("#0E0E10")),
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(image: NetworkImage(cover))),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => musicController.currentSong.value == id
                        ? Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          )),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      singer,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              InkWell(
                  onTap: () {
                    if (musicController.loveList.contains(id)) {
                      musicController.loveList.remove(id);
                    } else {
                      musicController.loveList.add(id);
                    }

                    favorite.write("favoriteList", musicController.loveList);
                  },
                  child: Obx(
                    () => musicController.loveList.contains(id)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.blue.shade900,
                            size: 25,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                            size: 25,
                          ),
                  )),
            ],
          ),
        ),
      ));
}
