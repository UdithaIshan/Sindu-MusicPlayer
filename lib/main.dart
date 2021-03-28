import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:sindu_player/player.dart';
import 'songList.dart';

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
                      ),
                      Container(
                        color: Colors.white,
                      ),
                      Container(
                        color: Colors.white,
                        // child: SongList(),
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
              child: Row(
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
                      PlayButton(),
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
              ))
        ],
      ),
    );
  }
}
