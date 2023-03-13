import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/constants.dart';
import 'package:note/controller/note/recordController.dart';
import 'package:note/widgets/home_widgets/notes_shape/delete_dialoge.dart';

class AudioWidget extends StatefulWidget {
  String? url;
  AudioWidget({Key? key, this.url}) : super(key: key);

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  final recordCtrl = Get.put(RecordController());
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    setUp();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  setUp() async {
    audioPlayer.play(widget.url!);
    audioPlayer.onAudioPositionChanged.listen((newDuration) {
      setState(() {
        position = newDuration;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (isPlaying == false) {
        audioPlayer.stop();
        duration = newDuration;
      }
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPlayerCompletion.listen((newDuration) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: mySecondTextColor, width: 1)),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 30),
                  onTap: () {
                    if (isPlaying) {
                      setState(() {
                        isPlaying = false;
                      });
                      pauseRecord();
                    } else {
                      setState(() {
                        isPlaying = true;
                      });
                      playRecord();
                    }
                  },
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    activeColor: mySecondaryColor,
                    inactiveColor: mySecondTextColor,
                    onChanged: (newVal) => seekTo(newVal.toInt()),
                  ),
                ),
                InkWell(
                  child: const Icon(Icons.delete),
                  onTap: () async {
                    bool? result = await showDeleteWarning(
                        context,
                        "deleteRecord",
                        "are You Sure you want to delete record");
                    if (result!) recordCtrl.deleteRecordFromSwap(widget.url!);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(duration.toString().split('.')[0]),
                  Text(position.toString().split('.')[0])
                ],
              ),
            )
          ],
        ));
  }

  seekTo(int sec) {
    audioPlayer.seek(Duration(seconds: sec));
  }

  playRecord() {
    isPlaying = true;
    audioPlayer.play(widget.url!);
  }

  pauseRecord() {
    audioPlayer.pause();
  }
}
