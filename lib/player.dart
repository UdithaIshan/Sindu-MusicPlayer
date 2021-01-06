import 'package:flutter/material.dart';
import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';

class PlayButton extends StatefulWidget {
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  AudioPlayer filePlayer;
  String _textFieldValue = '';

  void fileLoad() async {
    /// Loading an audio file into the player.
    bool result = await filePlayer.load(this._textFieldValue);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Audio file is loaded. Press FAB to play.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Audio file is could not be loaded.')));
    }
  }

  @override
  void initState() {
    super.initState();
    this.filePlayer = new AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: filePlayer.isPlaying
          ? Icon(Icons.pause)
          : Icon(Icons.play_arrow),
      iconSize: 36,
      color: Colors.blue,
      onPressed: () {
        this.setState(() {});
        fileLoad();
        if (!filePlayer.isLoaded) {
          final snackBar = SnackBar(
            content: Text('Load file first.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          if (filePlayer.isPaused) {
            /// Playing loaded audio file.
            this.filePlayer.play();
          } else if (filePlayer.isPlaying) {
            /// Pausing playback of loaded audio file.
            this.filePlayer.pause();
          }
        }
      },
    );
  }
}


// class Player extends StatefulWidget {
//   Player({Key key}) : super(key: key);
//   PlayerState createState() => PlayerState();
// }
//
// class PlayerState extends State<Player> {
//   /// Simple player implementation. Setting debug: true for extra logging.
//   AudioPlayer filePlayer;
//
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   String _textFieldValue = '';
//
//   @override
//   void initState() {
//     super.initState();
//     this.filePlayer = new AudioPlayer(id: 0, debug: true);
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: this._scaffoldKey,
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text('flutter_audio_desktop Demo'),
//         ),
//         body: Center(
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Divider(),
//           Padding(
//               padding: EdgeInsets.all(5),
//               child: Text(
//                 "File Settings: ",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               )),
//           Padding(
//             padding: EdgeInsets.all(5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: 150,
//                 ),
//                 SizedBox(
//                   width: 320,
//                   child: TextField(
//                     onChanged: (String value) {
//                       this._textFieldValue = value;
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Enter path to an audio file...',
//                       labelText: 'Audio Location',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 24,
//                 ),
//                 RaisedButton(
//                   child: Container(
//                     child: Text(
//                       "Load File",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   color: Colors.blue,
//                   onPressed: () async {
//                     /// Loading an audio file into the player.
//                     bool result = await filePlayer.load(this._textFieldValue);
//                     if (result) {
//                       this._scaffoldKey.currentState.showSnackBar(SnackBar(
//                           content: Text(
//                               'Audio file is loaded. Press FAB to play.')));
//                     } else {
//                       this._scaffoldKey.currentState.showSnackBar(SnackBar(
//                           content: Text('Audio file is could not be loaded.')));
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: filePlayer.isPlaying
//                       ? Icon(Icons.pause)
//                       : Icon(Icons.play_arrow),
//                   iconSize: 36,
//                   color: Colors.blue,
//                   onPressed: () {
//                     this.setState(() {});
//                     if (!filePlayer.isLoaded) {
//                       this._scaffoldKey.currentState.showSnackBar(SnackBar(
//                             content: Text('Load file first.'),
//                           ));
//                     } else {
//                       if (filePlayer.isPaused) {
//                         /// Playing loaded audio file.
//                         this.filePlayer.play();
//                       } else if (filePlayer.isPlaying) {
//                         /// Pausing playback of loaded audio file.
//                         this.filePlayer.pause();
//                       }
//                     }
//                   },
//                 ),
//                 Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.volume_down,
//                           size: 36,
//                           color: Colors.blue,
//                         ),
//                         Slider(
//                             divisions: 10,
//                             value: filePlayer.volume,
//                             onChanged: (value) {
//                               this.setState(() {
//                                 /// Changing player volume.
//                                 this.filePlayer.setVolume(value);
//                               });
//                             }),
//                         Icon(
//                           Icons.device_hub,
//                           size: 36,
//                           color: Colors.blue,
//                         ),
//                         Slider(
//                             divisions: filePlayer.devices.length > 0
//                                 ? filePlayer.devices.length
//                                 : 1,
//                             value: filePlayer.deviceIndex.toDouble(),
//                             min: 0,
//                             max: filePlayer.devices.length.toDouble(),
//                             onChanged: (value) {
//                               this.setState(() {
//                                 /// Changing player volume.
//                                 this
//                                     .filePlayer
//                                     .setDevice(deviceIndex: value.toInt());
//                               });
//                             }),
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ])));
//   }
// }
