import 'package:flutter/material.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get.dart';

class Instruction extends StatefulWidget {

  @override
  _InstructionState createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  late YoutubePlayerController _controller;

  void runYouTubePlayer() {
    _controller = YoutubePlayerController(
        initialVideoId: 'oOKldABeekk',
        flags: YoutubePlayerFlags(
          enableCaption: false,
          isLive: false,
          autoPlay: false,
        ));
  }

  @override
  void initState() {
    runYouTubePlayer();
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      builder: (context, player) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Get.back();
                },
              ),
              title: textWidget(
                '무물 사용 설명서', TextStyle(),
              ),
              backgroundColor: Colors.white,
            ),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                player,
                textWidget(
                  'wegolego Introduction Video',TextStyle())
              ],
            )));
      },
      player: YoutubePlayer(
        controller: _controller,
      ),
    );
  }
}
