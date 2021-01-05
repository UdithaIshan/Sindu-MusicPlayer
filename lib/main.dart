import "package:flutter/material.dart";
import 'favourite.dart';

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
                  trailing: IconButton(
                    icon: Icon(Icons.info_outline_rounded),
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
                    NavigationRailDestination(icon: Icon(Icons.play_circle_outline_rounded), selectedIcon: Icon(Icons.play_circle_fill_rounded), label: Text('Now'),),
                    NavigationRailDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: Text('Favourites'),),
                    NavigationRailDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: Text('All'),),
                  ],
                ),
                VerticalDivider(thickness: 1, width: 1),
                Expanded(
                    child: IndexedStack(
                      index: _widgetIndex,
                      children: [
                        Container(color: Colors.white,),
                        Container(color: Colors.blueAccent,),
                        Container(color: Colors.yellow,),
                      ],
                    ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1
          ),
          Container(
            color: Colors.white,
            height: 90.0,
          )
        ],
      ),
    );
  }
}
