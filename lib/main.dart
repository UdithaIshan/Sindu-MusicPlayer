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
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
                pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
              });
            },
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: Text('First'),),
              NavigationRailDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.book), label: Text('Second'),),
              NavigationRailDestination(icon: Icon(Icons.star_border), selectedIcon: Icon(Icons.star), label: Text('Third'),),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(child: PageView(
            controller: pageController,
            scrollDirection: Axis.vertical,
            children: [
              Container(color: Colors.white,),
              Container(color: Colors.blue,),
              Container(color: Colors.greenAccent,)
            ],
          ))
        ],
      ),
    );
  }
}
