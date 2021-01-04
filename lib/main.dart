import "package:flutter/material.dart";

void main() => runApp(MaterialApp(
      home: SinduMain(),
      debugShowCheckedModeBanner: false,
    ));

class SinduMain extends StatefulWidget {
  @override
  _SinduMainState createState() => _SinduMainState();
}

class _SinduMainState extends State<SinduMain> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.redAccent,
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: Text('First'),),
              NavigationRailDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.book), label: Text('Second'),),
              NavigationRailDestination(icon: Icon(Icons.star_border), selectedIcon: Icon(Icons.star), label: Text('Third'),),
            ],
          ),
          Expanded(child: PageView(
            children: [
              Container(color: Colors.black,),
              Container(color: Colors.blue,),
              Container(color: Colors.greenAccent,)
            ],
          ))
        ],
      ),
    );
  }
}
