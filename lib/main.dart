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
  int _selectedIndex = 0;
  PageController pageController = PageController();

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
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.ease);
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Favourite()),);
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
                    child: PageView(
                  allowImplicitScrolling: false,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      color: Colors.white,
                    ),
                    Container(
                      color: Colors.blue,
                    ),
                    Container(
                      color: Colors.greenAccent,
                    )
                  ],
                )),
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
