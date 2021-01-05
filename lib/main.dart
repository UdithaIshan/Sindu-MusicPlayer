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
          Container(
            color: Colors.black,
            height: 20.0,
          )
        ],
      ),
    );
  }
}
