import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PlayButton extends StatefulWidget {
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  Player player;
  IconData playButton = Icons.play_arrow;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    this.player = await Player.create(id: 0);
    Media media1 = await Media.network(
        'http://www.openmusicarchive.org/audio/Court_House_Blues_Take_1.mp3'
    );
    this.player.open(media1, autoStart: false);
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        if(!this.player.playback.isPlaying) {
          this.player.play();
          setState(() {
            playButton = Icons.pause;
          });
        } else {
          this.player.pause();
          setState(() {
            playButton = Icons.play_arrow;
          });
        }
      },
      elevation: 2.0,
      fillColor: Colors.white,
      child: Icon(
        playButton,
        size: 25.0,
      ),
      padding: EdgeInsets.all(10.0),
      shape: CircleBorder(),
    );
  }
}

