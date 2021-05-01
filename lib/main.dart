import 'dart:convert';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:play_me/models/playerData.dart';
import 'package:play_me/screens/StatefulListTile.dart';
import 'package:play_me/utils/core.dart';
import 'package:play_me/utils/window.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => PlayerData(),
    child: MaterialApp(
      home: PlayMe(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    ),
  ));

  doWhenWindowReady(() {
    final initialSize = Size(800, 600);
    appWindow.maxSize = initialSize;
    appWindow.minSize = initialSize;
    appWindow.title = 'PlayMe';
    appWindow.show();
  });
}

class PlayMe extends StatefulWidget {
  @override
  _PlayMeState createState() => _PlayMeState();
}

class _PlayMeState extends State<PlayMe> {
  int _widgetIndex = 0;
  int _selectedIndex = 0;

  // player configurations------------------------------------------------------
  PositionState position = new PositionState();
  PlaybackState playback = new PlaybackState();
  double currentVolume = 0.0;
  bool init = true;
  var metas;
  List<Device> devices = <Device>[];
  //----------------------------------------------------------------------------
  IconData playButton = Icons.play_arrow;
  IconData favButton = Icons.favorite_outline;
  IconData volumeButton = Icons.volume_up_sharp;
  IconData playListMode = Icons.repeat_sharp;
  Color repeatColor = Colors.black26;

  @override
  void didChangeDependencies() async {
    if (this.init) {
      super.didChangeDependencies();
      this.devices = await Devices.all;
      // check persistent store for saved favourites
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> favouriteMediaPaths = prefs.getStringList('favourites');
      try {
        await Future.forEach(favouriteMediaPaths, (item) async {
          Provider.of<PlayerData>(context)
              .addFavourites(await Media.file(new File(item)));
        });
      } catch (e) {}

      this.currentVolume =
          Provider.of<PlayerData>(context, listen: false).player.general.volume;
      Provider.of<PlayerData>(context, listen: false)
          .player
          .positionStream
          ?.listen((position) {
        this.setState(() => this.position = position);
      });

      Provider.of<PlayerData>(context, listen: false)
          .player
          .playbackStream
          ?.listen((playback) {
        if (playback.isPlaying) {
          playButton = Icons.pause;
          getMetas(Provider.of<PlayerData>(context, listen: false));
        } else {
          playButton = Icons.play_arrow;
        }
        this.setState(() => this.playback = playback);
      });

      this.setState(() {});
    }
    this.init = false;
  }

  void _openMediaFile(BuildContext context, medias) async {
    final mp3TypeGroup = XTypeGroup(
      label: 'MP3s',
      extensions: ['mp3'],
    );
    final files =
        await FileSelectorPlatform.instance.openFiles(acceptedTypeGroups: [
      mp3TypeGroup,
    ]);

    if (files.isNotEmpty) {
      medias.clear();

      await Future.forEach(files, (item) async {
        medias.add(await Media.file(new File(item.path)));
      });

      setState(() {});
    }
  }

  void getMetas(PlayerData data) async {
    try {
      Media metasMedia = await Media.file(
          new File(data.playFavourites
              ? data.favs[data.player.current.index].resource
              : data.medias[data.player.current.index].resource),
          parse: true);
      print('in meta ${data.player.current.index}');
      var jsonString =
          JsonEncoder.withIndent('    ').convert(metasMedia?.metas);
      this.metas = json.decode(jsonString);
      print(this.metas['artworkUrl']);
      // setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    Provider.of<PlayerData>(context, listen: false).player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playerData = context.watch<PlayerData>();

    return Scaffold(
      body: WindowBorder(
        color: Colors.white,
        width: 1,
        child: Column(
          children: [
            Row(children: [LeftSide(), RightSide()]),
            Expanded(
              child: Row(
                children: [
                  NavigationRail(
                    selectedLabelTextStyle: TextStyle(
                      color: Colors.white
                    ),
                    selectedIconTheme: IconThemeData(
                        color: Colors.white
                    ),
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
                  // VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: IndexedStack(
                      index: _widgetIndex,
                      children: [
                        Container(
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  this.playback.isPlaying
                                      ? 'Now Playing'
                                      : 'Welcome to PlayMe',
                                  style: TextStyle(
                                      fontSize: 30, fontFamily: 'Courgette'),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500.0),
                                          child: metas != null ? Image.file(
                                            File(Uri.decodeComponent(
                                                        metas['artworkUrl'])
                                                    .replaceAll('file:///', '')
                                                ),
                                            width: 300,
                                            height: 300,
                                          ) :
                                          Image(
                                            width: 300,
                                            height: 300,
                                            image: AssetImage('assets/images/PlayMeLogo.png'),
                                          ),
                                      ),
                                    ),
                                    Container(
                                      child: Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              metas != null
                                                  ? metas['title']
                                                  : 'PlayMe with your favourites!',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Divider(
                                              height: 19,
                                            ),
                                            Text(
                                              metas != null
                                                  ? metas['artist']
                                                  : '',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Scaffold(
                            appBar: PreferredSize(
                              preferredSize: Size.fromHeight(30.0),
                              child: AppBar(
                                elevation: 0,
                                backgroundColor: Color(0xff303030),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xffeb1555),
                                      ),
                                      child: const Text('Play Favourites'),
                                      onPressed: () {
                                        playerData.togglePlayFavourites(true);
                                        playerData.player.open(
                                            new Playlist(medias: playerData.favs),
                                            autoStart: true);
                                      }),
                                  SizedBox(width: 20,)
                                ],
                              ),
                            ),
                            body: Container(
                              child: ListView.builder(
                                  itemCount: playerData.favs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (playerData.favs.isEmpty) {
                                      return null;
                                    }
                                    return Container(
                                      decoration: new BoxDecoration(
                                        border: new Border.all(width: 0.04, color: Colors.grey),
                                      ),
                                      child: ListTile(
                                        title: FutureBuilder(
                                            future: Core.getNameOfThis(
                                                playerData.favs[index]),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(snapshot.data);
                                              }
                                              return Text('snapshot.data');
                                            }),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline_sharp,
                                          ),
                                          splashRadius: 20,
                                          // tooltip: 'Remove from favourites',
                                          onPressed: () {
                                            playerData
                                                .removeFavouritesByIndex(index);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: Scaffold(
                            appBar: PreferredSize(
                              preferredSize: Size.fromHeight(30.0),
                              child: AppBar(
                                elevation: 0,
                                backgroundColor: Color(0xff303030),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffeb1555),
                                    ),
                                    child: const Text('Open files'),
                                    onPressed: () => _openMediaFile(
                                        context, playerData.medias),
                                  ),
                                  SizedBox(width: 10,),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffeb1555),
                                    ),
                                      child: const Text('Play All'),
                                      onPressed: () {
                                        playerData.togglePlayFavourites(false);
                                        playerData.player.open(
                                            new Playlist(
                                                medias: playerData.medias),
                                            autoStart: true);
                                      }),
                                  SizedBox(width: 20,)
                                ],
                              ),
                            ),
                            body: Container(
                                child: ListView.builder(
                                    itemCount: playerData.medias.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return StatefulListTile(index: index);
                                    })),
                          ),
                        ),
                        Container(
                            color: Color(0xff303030),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 300,
                                      height: 300,
                                      child: Card(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Text(
                                              'Set Playback Rate',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Text(
                                                'Current Rate: ${playerData.player?.general?.rate ?? 1.0}'),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            SliderTheme(
                                              data: SliderTheme.of(context).copyWith(
                                                activeTrackColor: Color(0xffeb1555),
                                                inactiveTrackColor: Colors.red[200],
                                                trackShape: RectangularSliderTrackShape(),
                                                trackHeight: 4.0,
                                                thumbColor: Color(0xffeb1555),
                                                thumbShape: RoundSliderThumbShape(
                                                    enabledThumbRadius: 8.0),
                                                overlayColor: Colors.cyan.withAlpha(32),
                                                overlayShape:
                                                RoundSliderOverlayShape(overlayRadius: 10.0),
                                              ),
                                              child: Slider(
                                                min: 0.0,
                                                max: 2.0,
                                                divisions: 4,
                                                value: playerData
                                                        .player?.general?.rate ??
                                                    1.0,
                                                onChanged: (value) {
                                                  playerData.player
                                                      .setRate(value);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 300,
                                      child: Card(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Text(
                                              'Set Playback Device',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: this.devices != null ? this.devices.length : 0,
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      leading: Text('${index + 1}.'),
                                                      title: Text(
                                                        this.devices[index].name,
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      onTap: () => playerData
                                                          .player
                                                          ?.setDevice(this.devices[index]),
                                                    );
                                                  }
                                              ),
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 2),
            Container(
              color: Colors.blueGrey.shade800,
              padding: EdgeInsets.all(10),
                height: 110.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Core.getDurationFormatted(
                            this.position.position.inSeconds)),
                        Container(
                          height: 20,
                          width: 300,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Color(0xffeb1555),
                              inactiveTrackColor: Colors.red[200],
                              trackShape: RectangularSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbColor: Color(0xffeb1555),
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 9.0),
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
                                playerData.player.seek(
                                  Duration(milliseconds: value.toInt()),
                                );
                              },
                            ),
                          ),
                        ),
                        Text(Core.getDurationFormatted(
                            this.position.duration.inSeconds)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(

                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RawMaterialButton(
                                constraints: BoxConstraints(maxWidth: 50),
                                onPressed: () {
                                  if(playerData.playlistMode == PlaylistMode.single) {
                                    playerData.togglePlayListMode(PlaylistMode.repeat);
                                    setState(() {
                                      repeatColor = Colors.grey;
                                      playListMode = Icons.repeat_one_sharp;
                                    });
                                  }
                                  else if(playerData.playlistMode == PlaylistMode.repeat) {
                                    playerData.togglePlayListMode(PlaylistMode.loop);
                                    setState(() {
                                      playListMode = Icons.repeat_sharp;
                                    });
                                  }
                                  else if(playerData.playlistMode == PlaylistMode.loop) {
                                    playerData.togglePlayListMode(PlaylistMode.single);
                                    setState(() {
                                      repeatColor = Colors.black26;
                                      playListMode = Icons.repeat_sharp;
                                    });
                                    }
                                },
                                elevation: 2.0,
                                fillColor: repeatColor,
                                child: Icon(
                                  playListMode,
                                  size: 20.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                constraints: BoxConstraints(maxWidth: 50),
                                onPressed: () => playerData.player.stop(),
                                elevation: 2.0,
                                fillColor: Colors.black26,
                                child: Icon(
                                  Icons.stop,
                                  size: 20.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              constraints: BoxConstraints(maxWidth: 50),
                              onPressed: () => playerData.player.back(),
                              elevation: 2.0,
                              fillColor: Colors.black26,
                              child: Icon(
                                FontAwesomeIcons.caretLeft,
                                size: 25.0,
                              ),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                if (playerData.medias.isNotEmpty ||
                                    playerData.favs.isNotEmpty) {
                                  if (playback.isPlaying) {
                                    playerData.player.pause();
                                  } else {
                                    playerData.player.play();
                                  }
                                }
                              },
                              elevation: 2.0,
                              fillColor: Colors.black26,
                              child: Icon(
                                playButton,
                                size: 30.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                            RawMaterialButton(
                              constraints: BoxConstraints(maxWidth: 50),
                              onPressed: () => playerData.player.next(),
                              elevation: 2.0,
                              fillColor: Colors.black26,
                              child: Icon(
                                FontAwesomeIcons.caretRight,
                                size: 25.0,
                              ),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            ),
                          ],
                        )),
                        Expanded(
                          // volume controller
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(volumeButton),
                                iconSize: 25,
                                splashRadius: 20,
                                onPressed: () {
                                  if (playerData.player.general.volume != 0.0) {
                                    currentVolume =
                                        playerData.player.general.volume;
                                    playerData.player.setVolume(0.0);
                                    setState(() {
                                      volumeButton = Icons.volume_off_sharp;
                                    });
                                  } else {
                                    playerData.player.setVolume(currentVolume);
                                    setState(() {
                                      volumeButton = Icons.volume_up_sharp;
                                    });
                                  }
                                },
                              ),
                              Container(
                                width: 125,
                                height: 50,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Color(0xffeb1555),
                                    inactiveTrackColor: Colors.red[200],
                                    trackShape: RectangularSliderTrackShape(),
                                    trackHeight: 4.0,
                                    thumbColor: Color(0xffeb1555),
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 8.0),
                                    overlayColor: Colors.cyan.withAlpha(32),
                                    overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 10.0),
                                  ),
                                  child: Slider(
                                    min: 0.0,
                                    max: 1.0,
                                    value: playerData.player?.general?.volume ?? 0.5,
                                    onChanged: (value) {
                                      playerData.player.setVolume(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
