import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              // flex: 10,
              child: Row(
                children: [
                  NavigationRail(
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
                      child: Container(
                    color: Colors.black,
                  ))
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
