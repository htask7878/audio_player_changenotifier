import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Model extends ChangeNotifier {
  OnAudioQuery audioQuery = OnAudioQuery();
  PageController pagecontroller = PageController();
  bool isPlaying = false;
  Duration duration1 = Duration.zero;
  double position = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  String path = "";

  //todo permission fun
  permission() async {
    var status = await Permission.storage.status;
    print(status);
    if (status.isDenied) {
      await Permission.storage.request().isGranted;
    } else {
      print("permission already granted");
    }
  }

  //todo Future fun
  Future<List<SongModel>> getSong() async {
    var status = await Permission.storage.status;
    print(status);
    if (status.isDenied) {
      await Permission.storage.request().isGranted;
    } else {
      print("permission already granted");
    }
    List<SongModel> allSongList = await audioQuery.querySongs();
    return allSongList;
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }

  //todo page change
  pageChange() async {
    await audioPlayer.pause();
    position = 0;
    notifyListeners(); //todo setState jevu kam
  }

  //todo Slider change
  // sliderChange(int value) async {
  //   await audioPlayer.seek(Duration(milliseconds: value.toInt()));
  //   await audioPlayer.resume();
  //   print("seek&resume");
  //   notifyListeners(); //todo setState jevu kam
  // }

  //TODO previousSide song --
  previousSideSong(int index, List<SongModel> list) async {
    await audioPlayer.pause();
    if (index > 0) {
      index--;
      print("index-- = $index");
      position = 0;
      path = list[index].data;
      print("path1 = $path");
      await audioPlayer.play(DeviceFileSource(path));
    } else {
      list.length - 1;
      position = 0;
      path = list[index].data;
      print("path2 = $path");
      await audioPlayer.play(DeviceFileSource(path));
    }
    pagecontroller.previousPage(
        duration: Duration(microseconds: 200), curve: Curves.easeInCubic);
    notifyListeners(); //TODO setState
    pagecontroller.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
    // notifyListeners(); //TODO setState
  }

  //TODO pause & start Song
  stopStart(int index, List<SongModel> list) async {
    if (isPlaying) {
      await audioPlayer.pause();
      print("pause");
    } else {
      path = "${list[index].data}";
      print("path3 = $path");
      await audioPlayer.play(DeviceFileSource(path));
    }
    notifyListeners(); //TODO setState jevu kam
    isPlaying = !isPlaying;
  }

  //TODO next side song ++
  nextSideSong(int index, List<SongModel> list) async {
    await audioPlayer.pause();
    if (index < list.length - 1) {
      index++;
      print("index4 = $index");
      position = 0;
      path = list[index].data;
      print("path4 = $path");

      await audioPlayer.play(DeviceFileSource(path));
    } else {
      index = 0;
      print("index0 = $index");
      position = 0;
      path = list[index].data;
      print("path5 = $path");
      await audioPlayer.play(DeviceFileSource(path));
    }
    pagecontroller.nextPage(
        duration: Duration(microseconds: 200), curve: Curves.easeInCubic);
    notifyListeners();
    pagecontroller.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
  }
  test() {
    audioPlayer.onPositionChanged.listen((Duration p) {
      print("P=$p");
        position = p.inMilliseconds.toDouble();
    });
    notifyListeners();
  }
}
