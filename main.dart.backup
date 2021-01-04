import 'package:flutter/material.dart';
import 'package:flutter_audio_desktop/flutter_audio_desktop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Taste of Music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer filePlayer;
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _textFieldValue = '';

  @override
  void initState() {
    super.initState();
    this.filePlayer = new AudioPlayer(id: 0, debug: true);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: this._scaffoldKey,

        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              // flex: 10,
              child: Row(
                children: [
                  NavigationRail(
                    leading: FlutterLogo(),
                    groupAlignment: -1,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.selected,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite_border),
                        selectedIcon: Icon(Icons.favorite),
                        label: Text('First'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bookmark_border),
                        selectedIcon: Icon(Icons.book),
                        label: Text('Second'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.star_border),
                        selectedIcon: Icon(Icons.star),
                        label: Text('Third'),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                          ),
                          SizedBox(
                            width: 320,
                            child: TextField(
                              onChanged: (String value) {
                                this._textFieldValue = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter path to an audio file...',
                                labelText: 'Audio Location',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          RaisedButton(
                            child: Container(
                              child: Text(
                                "Load File",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: Colors.blue,
                            onPressed: () async {
                              /// Loading an audio file into the player.
                              bool result = await filePlayer.load(this._textFieldValue);
                              if (result) {
                                this._scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text(
                                        'Audio file is loaded. Press FAB to play.')));
                              } else {
                                this._scaffoldKey.currentState.showSnackBar(SnackBar(
                                    content: Text('Audio file is could not be loaded.')));
                              }
                            },
                          ),
                          IconButton(
                            icon: filePlayer.isPlaying
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow),
                            iconSize: 36,
                            color: Colors.blue,
                            onPressed: () {
                              this.setState(() {});
                              if (!filePlayer.isLoaded) {
                                this._scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Load file first.'),
                                ));
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
                          ),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.volume_down,
                                    size: 36,
                                    color: Colors.blue,
                                  ),
                                  Slider(
                                      divisions: 10,
                                      value: filePlayer.volume,
                                      onChanged: (value) {
                                        this.setState(() {
                                          /// Changing player volume.
                                          this.filePlayer.setVolume(value);
                                        });
                                      }),
                                  Icon(
                                    Icons.device_hub,
                                    size: 36,
                                    color: Colors.blue,
                                  ),
                                  Slider(
                                      divisions: filePlayer.devices.length > 0
                                          ? filePlayer.devices.length
                                          : 1,
                                      value: filePlayer.deviceIndex.toDouble(),
                                      min: 0,
                                      max: filePlayer.devices.length.toDouble(),
                                      onChanged: (value) {
                                        this.setState(() {
                                          /// Changing player volume.
                                          this
                                              .filePlayer
                                              .setDevice(deviceIndex: value.toInt());
                                        });
                                      }),
                                ],
                              )),
                        ],
                      ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.amber,
              height: 80.0,
            )
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
