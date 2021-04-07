import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:sindu_player/songList.dart';

void main() => runApp(MaterialApp(
      home: SinduMain(),
      debugShowCheckedModeBanner: false,
    ));

class SinduMain extends StatefulWidget {
  @override
  _SinduMainState createState() => _SinduMainState();
}

class _SinduMainState extends State<SinduMain> {
  int _widgetIndex = 0;
  int _selectedIndex = 0;
  double _value = 0;

  // player config--------------------------------------------------------------
  Player player;
  PositionState position = new PositionState();
  List<Media> medias = <Media>[];
  bool init = true;
  //----------------------------------------------------------------------------

  IconData playButton = Icons.play_arrow;

  @override
  void didChangeDependencies() async {
    if(this.init) {
      super.didChangeDependencies();
      this.player = await Player.create(id: 0);
      this.player.positionStream.listen((position) {
        this.setState(() => this.position = position);
      });
      Media media1 = await Media.network(
          'http://www.openmusicarchive.org/audio/Court_House_Blues_Take_1.mp3');
      this.player.open(media1, autoStart: false);
      this.setState(() {});
    }
    this.init = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.selected,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                      _widgetIndex = index;
                    });
                  },
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.play_circle_outline_rounded),
                      selectedIcon: Icon(Icons.play_circle_fill_rounded),
                      label: Text('Now'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_border),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favourites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.folder_outlined),
                      selectedIcon: Icon(FontAwesomeIcons.solidFolderOpen),
                      label: Text('All'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _widgetIndex,
                    children: [
                      Container(
                        color: Colors.white,
                        child: SongList(),
                      ),
                      Container(
                        color: Colors.white,
                      ),
                      Container(
                        color: Colors.white,
                        child: SongPicker(medias: medias, player: player,),
                      ),
                      Container(
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
              height: 90.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 300,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.red[700],
                        inactiveTrackColor: Colors.red[100],
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbColor: Colors.redAccent,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 10.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: this
                            .position
                            .duration
                            .inMilliseconds
                            .toDouble(),
                        value: this
                            .position
                            .position
                            .inMilliseconds
                            .toDouble(),
                        onChanged: (value) {
                          this.player.seek(
                            Duration(
                                milliseconds: value.toInt()),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(FontAwesomeIcons.caretLeft),
                            iconSize: 50.0,
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              if (!this.player.playback.isPlaying) {
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
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.caretRight),
                            iconSize: 50.0,
                          ),
                        ],
                      )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.volume_down,
                              size: 25,
                              color: Colors.blue,
                            ),
                            Container(
                              width: 100,
                              height: 50,
                              child: Slider(
                                min: 0,
                                max: 100.0,
                                divisions: 10,
                                value: 0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class SongPicker extends StatefulWidget {
  final List<Media> medias;
  final Player player;

  SongPicker({Key key, this.medias, this.player}): super(key: key);

  @override
  _SongPickerState createState() => _SongPickerState();
}

class _SongPickerState extends State<SongPicker> {

  void _openImageFile(BuildContext context) async {
    final mp3TypeGroup = XTypeGroup(
      label: 'MP3s',
      extensions: ['mp3'],
    );
    final files =
    await FileSelectorPlatform.instance.openFiles(acceptedTypeGroups: [
      mp3TypeGroup,
    ]);

    await Future.forEach(files, (item) async {
      widget.medias.add(await Media.file(new File(item.path)));
    });

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.medias.isNotEmpty) {
      return Container(
        child: ListView.builder(
          itemCount: widget.medias.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.medias[index].resource),
                onTap: () => {
                  widget.player.open(widget.medias[index])
                },
              );
            }
        )
      );
    }
    return ElevatedButton(
      child: const Text('Press to open multiple images (png, jpg)'),
      onPressed: () => _openImageFile(context),
    );
  }
}

