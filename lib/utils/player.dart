import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';

class Player {
  AudioPlayer player;

  // 工厂模式
  factory Player() => _getInstance();

  static Player get instance => _getInstance();
  static Player _instance;

  Player._internal() {
    // 初始化
    if (player == null) {
      player = AudioPlayer();
    }
  }

  static Player _getInstance() {
    if (_instance == null) {
      _instance = Player._internal();
    }
    return _instance;
  }

  listen(
      {onDurationChanged,
      onAudioPositionChanged,
      onPlayerStateChanged,
      onPlayerCompletion,
      onPlayerError}) {
    if (onDurationChanged != null) {
      player.onAudioPositionChanged
          .listen((Duration p) => onDurationChanged(p));
    }
    if (onAudioPositionChanged != null) {
      player.onAudioPositionChanged
          .listen((Duration p) => onAudioPositionChanged(p));
    }
    if (onPlayerStateChanged != null) {
      player.onPlayerStateChanged
          .listen((AudioPlayerState s) => onPlayerStateChanged(s));
    }
    if (onPlayerCompletion != null) {
      player.onPlayerCompletion.listen((event) => onPlayerCompletion(event));
    }
    if (onPlayerError != null) {
      player.onPlayerError.listen((msg) => onPlayerError(msg));
    }
  }

  // 第一次播放
  play(String url) async {
    await this.release();
    int result = await player.play(url);
    if (result == 1) {
      // success
    } else {
      BotToast.showText(text: '资源不存在');
    }
  }

  // 暂停
  pause() async {
    int result = await player.pause();
    if (result == 1) {
      // success
    } else {
      BotToast.showText(text: '暂停失败');
    }
  }

  // 继续播放
  resume() async {
    int result = await player.resume();
    if (result == 1) {
      // success
    } else {
      BotToast.showText(text: '播放失败');
    }
  }

  // reset
  stop() async {
    int result = await player.stop();
    if (result == 1) {
      // success
    } else {
      BotToast.showText(text: '重新失败');
    }
  }

  // 释放
  release() async {
    int result = await player.release();
    if (result == 1) {
      // success
    } else {
      BotToast.showText(text: '释放失败');
    }
  }
}
