import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';

String _textFieldValue = '';
List<XFile> _files = [];
Duration _songDuration;
int i;

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {

  Future<List<XFile>> _openFile(BuildContext context) async {
    // List<XFile> files = [];
    final XTypeGroup mp3TypeGroup = XTypeGroup(
      label: 'MP3s',
      extensions: ['mp3'],
    );
    var _newFiles = await openFiles(acceptedTypeGroups: [
      mp3TypeGroup,
    ]);
    setState(() {
      _files = _newFiles;
    });
  }
  //
  // void fileLoad(context) async {
  //   /// Loading an audio file into the player.
  //   bool result = await filePlayer.load(this._textFieldValue);
  //   if (result) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //             'Audio file is loaded. Press FAB to play.')));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Audio file is could not be loaded.')));
  //   }
  //   if (!filePlayer.isLoaded) {
  //     final snackBar = SnackBar(
  //       content: Text('Load file first.'),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else {
  //     if (filePlayer.isPaused) {
  //       /// Playing loaded audio file.
  //       this.filePlayer.play();
  //     } else if (filePlayer.isPlaying) {
  //       /// Pausing playback of loaded audio file.
  //       this.filePlayer.pause();
  //     }
  //   }
  // }

  Widget _SongTile(path) {
    return Card(
      child: ListTile(
        horizontalTitleGap: 20.0,
        tileColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.play_circle_outline_rounded),
        ),
        title: Text(basename(path)),
        trailing: IconButton(
          icon: Icon(Icons.favorite_outline_rounded),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Open your songs list'),
            onPressed: () {
              _openFile(context);
            }),
        Expanded(
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: (context, index) {
              return _SongTile(_files[index].path);
            },
          ),
        ),
      ],
    );
  }
}

class PlayButton extends StatefulWidget {
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  AudioPlayer filePlayer;

  void filePlay(context) async {
     i = 0;
    while(_files != null && i < _files.length && filePlayer.isStopped) {
      _textFieldValue = _files[i].path;
      await testPlay();
      i++;
      print(i);
    }
  }

  Future songDuration(AudioPlayer player) async {
     _songDuration = await player.getDuration();
  }

  // void fileLoad(context) async {
  //   bool result = await filePlayer.load(_textFieldValue);
  //   if (result) {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //     SnackBar(content: Text('Audio file is loaded')));
  //     songDuration(filePlayer);
  //     setState(() {
  //       filePlayer.play();
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Audio file is could not be loaded.')));
  //   }
  // }

  //test start

  Future fileLoad(context) async {
    bool result = await filePlayer.load(_textFieldValue);
    if (result) {
      await songDuration(filePlayer);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio file is could not be loaded.')));
    }
  }

  Future testPlay() async {
     await fileLoad(context);
    setState(() {
      filePlayer.play();
    });
    await Future.delayed(_songDuration, () {
      // Pause the playback.
      setState(() {
        filePlayer.stop();
        print('Playback of audio stopped after $_songDuration seconds.');
      });
    }
    );
  }

  @override
  void initState() {
    super.initState();
    this.filePlayer = new AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: filePlayer.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        iconSize: 36,
        color: Colors.blue,
        onPressed: () {
          setState(() {});
          if (!filePlayer.isLoaded) {
            // fileLoad(context);
            filePlay(context);
          } else if (filePlayer.isPlaying) {
            setState(() {
              this.filePlayer.pause();
            });
          } else if (filePlayer.isPaused) {
            setState(() {
              this.filePlayer.play();
            });
          }
        });
  }
}
