import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

class MusicController extends GetxController {
  final firstPlay = false.obs;

  final loopList = [].obs;

  final loveList = [].obs; // Chứa id của những bài hát yêu thích từ bộ nhớ

  // lưu id của bài hết đang phát để đổi màu tiêu đề của bài hát đó trên danh sách bài hát
  final currentSong = "".obs;

  updateFirstPlayStatus(bool isFirstPlay) {
    firstPlay(isFirstPlay);
  }

  updateLoopList(List<Audio> audioList) {
    loopList(audioList);
  }

  updateLoveList(List list) {
    loveList(list);
  }

  updateCurrentSong(String id) {
    currentSong(id);
  }
}
