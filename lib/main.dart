import 'dart:convert';
import 'dart:io';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:play_me/PlayerData.dart';
import 'package:play_me/screens/StatefulListTile.dart';
import 'package:provider/provider.dart';

void main() => runApp(
    ChangeNotifierProvider(
      create: (context) => PlayerData(),
      child: MaterialApp(
        home: SinduMain(),
        debugShowCheckedModeBanner: false,
      ),
    ));

class SinduMain extends StatefulWidget {
  @override
  _SinduMainState createState() => _SinduMainState();
}

class _SinduMainState extends State<SinduMain> {

  int _widgetIndex = 0;
  int _selectedIndex = 0;

  // player config--------------------------------------------------------------
  Player player;
  CurrentState current = new CurrentState();
  PositionState position = new PositionState();
  PlaybackState playback = new PlaybackState();
  GeneralState general = new GeneralState();
  var metas;
  bool init = true;
  //----------------------------------------------------------------------------

  IconData playButton = Icons.play_arrow;
  IconData favButton = Icons.favorite_outline;
  IconData volumeButton = Icons.volume_up_sharp;

  double currentVolume = 0.0;

  @override
  void didChangeDependencies() async {
    if (this.init) {
      super.didChangeDependencies();
      this.player = await Player.create(id: 0);
      this.player?.currentStream?.listen((current) {
        this.setState(() => this.current = current);
        // getMetas();
      });
      this.currentVolume = this.player.general.volume;
      this.player?.positionStream?.listen((position) {
        this.setState(() => this.position = position);
      });
      this.player?.playbackStream?.listen((playback) {
        if (playback.isPlaying) {
          playButton = Icons.pause;

          getMetas(this.player);
        } else {
          playButton = Icons.play_arrow;
        }
        this.setState(() => this.playback = playback);
      });
      this.player?.generateStream?.listen((general) {
        this.setState(() => this.general = general);
      });
      // this.player.open(new Playlist(medias: medias), autoStart: false);
      this.setState(() {});
    }
    this.init = false;
  }

  void _openMediaFile(BuildContext context, medias) async {
    final mp3TypeGroup = XTypeGroup(
      label: 'MP3s',
      extensions: ['mp3'],
    );
    final files = await FileSelectorPlatform.instance.openFiles(acceptedTypeGroups: [
      mp3TypeGroup,
    ]);

    if (files.isNotEmpty) {
      medias.clear();

      await Future.forEach(files, (item) async {
        medias.add(await Media.file(new File(item.path)));
      });

      // await Future.forEach(medias, (item) async {
      //   await player.add(item);
      // });

      setState(() {});
    }
  }

  void getMetas(Player player) async {
    try {

      Media metasMedia = await Media.file(
          new File(Provider.of<PlayerData>(context, listen: false).playFavourites ? Provider.of<PlayerData>(context, listen: false).favs[this.player.current.index].resource : Provider.of<PlayerData>(context, listen: false).medias[this.player.current.index].resource),
          parse: true);
      print('in meta ${this.player.current.index}');
      var jsonString =
      JsonEncoder.withIndent('    ').convert(metasMedia?.metas);
      this.metas = json.decode(jsonString);
      print(this.metas['artworkUrl']);
      // setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<String> getNameOfThis(Media media) async {
    try {
      Media metaMedia = await Media.file(new File(media.resource), parse: true);
      var jsonString = JsonEncoder.withIndent('    ').convert(metaMedia?.metas);
      var meta = json.decode(jsonString);
      return meta != null ? meta['title'] : '';
    } catch (e) {
      return "Can't get the data 💔";
    }
  }

  String getDurationFormatted(int seconds) {
    if(seconds % 60 == 0) {
      int minutes = seconds ~/ 60;
      return '$minutes:00';
    }
    else {
      int remainder = seconds % 60;
      int value = seconds ~/ 60;
      return '$value:${remainder > 9 ? remainder : '0$remainder'}';
    }
  }

  @override
  void dispose() {
    this.player.dispose();
    super.dispose();

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
                        child: Container(
                          padding: EdgeInsets.only(left: 20, top: 0, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                this.playback.isPlaying ? 'Now Playing' : 'Welcome to PlayMe',
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
                                        child: Image.file(
                                          new File(metas != null
                                              ? Uri.decodeComponent(
                                              metas['artworkUrl'])
                                              .replaceAll('file:///', '')
                                              : './assets/images/Sindu.gif'),
                                          width: 300,
                                          height: 300,
                                        )),
                                  ),
                                  Container(
                                    child: Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // SizedBox(
                                          //   height: 100,
                                          // ),
                                          Text(
                                            metas != null ? metas['title'] : 'PlayMe with your favourites!',
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
                                          ),
                                          // Text(
                                          //   metas != null ? metas['genre'] : '',
                                          //   style: TextStyle(
                                          //       fontWeight: FontWeight.bold),
                                          // ),
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
                        color: Colors.white,
                        child: Scaffold(
                          appBar: AppBar(
                            actions: [
                              ElevatedButton(
                                  child: const Text('Play Favourites'),
                                  onPressed: () {
                                    Provider.of<PlayerData>(context, listen: false).togglePlayFavourites(true);
                                    player.open(new Playlist(medias: Provider.of<PlayerData>(context, listen: false).favs),
                                        autoStart: true);
                                    // setState(() {
                                    //   playButton = Icons.pause;
                                    // });
                                  }),
                            ],
                          ),
                          body: Container(
                            child: ListView.builder(
                                itemCount: Provider.of<PlayerData>(context).favs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (Provider.of<PlayerData>(context).favs.isEmpty) {
                                    return null;
                                  }
                                  return ListTile(
                                    title: FutureBuilder(
                                        future: getNameOfThis(Provider.of<PlayerData>(context).favs[index]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(snapshot.data);
                                          }
                                          return Text('snapshot.data');
                                        }),
                                    trailing:
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline_sharp),
                                      onPressed: () {
                                        Provider.of<PlayerData>(context, listen: false).removeFavouritesByIndex(index);
                                        setState(() {

                                        });
                                      },
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Scaffold(
                          appBar: AppBar(
                            actions: [
                              ElevatedButton(
                                child: const Text('Open files'),
                                onPressed: () => _openMediaFile(context, Provider.of<PlayerData>(context, listen: false).medias),
                              ),
                              ElevatedButton(
                                  child: const Text('Play All'),
                                  onPressed: () {
                                    Provider.of<PlayerData>(context, listen: false).togglePlayFavourites(false);
                                    player.open(new Playlist(medias: Provider.of<PlayerData>(context, listen: false).medias), autoStart: true);
                                    // setState(() {
                                    //   playButton = Icons.pause;
                                    // });
                                  }),
                            ],
                          ),
                          body: Container(
                              child: ListView.builder(
                                  itemCount: Provider.of<PlayerData>(context).medias.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return StatefulListTile(
                                      // title: Provider.of<PlayerData>(context).medias[index].resource,
                                      // favs: this.favs,
                                      // medias: this.medias,
                                      index: index,
                                      // isFavs: this.isFavs,
                                    );
                                  })
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 300,
                                  height: 300,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Text('Set Playback Rate'),
                                        Text('Current Rate: ${this.player.general.rate}'),
                                        Slider(
                                          min: 0.0,
                                          max: 2.0,
                                          divisions: 4,
                                          value: player?.general.rate ?? 1.0,
                                          onChanged: (value) {
                                            this.player.setRate(value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Container(
                                width: 300,
                                height: 300,
                                child: Card(
                                    child: Text('Coming Soon'),
                                ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Container(
              height: 110.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getDurationFormatted(this.position.position.inSeconds)),
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
                            max: this.position.duration.inMilliseconds.toDouble(),
                            value: this.position.position.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              this.player.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(getDurationFormatted(this.position.duration.inSeconds)),
                    ],
                  ),
                  Row(                                    // playback controllers
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RawMaterialButton(
                              constraints: BoxConstraints(maxWidth: 50),
                              onPressed: () => player.stop(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              child: Icon(
                                FontAwesomeIcons.stop,
                                size: 15.0,
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
                                onPressed: () => player.back(),
                                elevation: 2.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  FontAwesomeIcons.caretLeft,
                                  size: 25.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  if(Provider.of<PlayerData>(context, listen: false).medias.isNotEmpty || Provider.of<PlayerData>(context, listen: false).favs.isNotEmpty) {
                                    getMetas(this.player);
                                    if (playback.isPlaying) {
                                      this.player.pause();
                                    } else {
                                      this.player.play();
                                    }
                                  }

                                },
                                elevation: 2.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  playButton,
                                  size: 30.0,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                constraints: BoxConstraints(maxWidth: 50),
                                onPressed: () => player.next(),
                                elevation: 2.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  FontAwesomeIcons.caretRight,
                                  size: 25.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(),
                              ),
                            ],
                          )),
                      Expanded(                     // volume controller
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(volumeButton),
                              iconSize: 25,
                              color: Colors.blue,
                              onPressed: () {
                                if (player.general.volume != 0.0) {
                                  currentVolume = this.player.general.volume;
                                  player.setVolume(0.0);
                                  setState(() {
                                    volumeButton = Icons.volume_off_sharp;
                                  });
                                } else {
                                  player.setVolume(currentVolume);
                                  setState(() {
                                    volumeButton = Icons.volume_up_sharp;
                                  });
                                }
                              },
                            ),
                            Container(
                              width: 100,
                              height: 50,
                              child: Slider(
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                value: player?.general?.volume ?? 0.5,
                                onChanged: (value) {
                                  this.player.setVolume(value);
                                  // setState(() {
                                  // });
                                },
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