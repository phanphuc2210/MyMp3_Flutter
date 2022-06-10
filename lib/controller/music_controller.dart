import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

class MusicController extends GetxController {
  final firstPlay = false.obs;

  final loopList = [].obs;

  updateFirstPlayStatus(bool isFirstPlay) {
    firstPlay(isFirstPlay);
  }

  updateLoopList(List<Audio> audioList) {
    loopList(audioList);
  }
}
