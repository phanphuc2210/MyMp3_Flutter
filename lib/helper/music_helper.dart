import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:my_mp3/model/audio_model.dart';

Audio find(List<Audio> source, String fromPath) {
  return source.firstWhere((element) => element.path == fromPath);
}

List<Audio> fromMusicToAudio(List<MusicSnapshot> snapShot) {
  List<Audio> audios = [];
  for (var snap in snapShot) {
    Audio audio = Audio.network(snap.music!.url,
        metas: Metas(
            id: snap.music!.id,
            title: snap.music!.title,
            image: MetasImage.network(snap.music!.coverUrl),
            artist: snap.music!.singer,
            extra: {"lyric": snap.music!.lyric}));
    audios.add(audio);
  }

  return audios;
}
