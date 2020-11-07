import 'package:flutter/material.dart';
import 'package:sindu_music_player/screens/sindu_player.dart';
import 'package:sindu_music_player/screens/sindu_fav.dart';
import 'package:sindu_music_player/screens/sindu_list.dart';

class SinduHome extends StatefulWidget {
  @override
  _SinduHomeState createState() => _SinduHomeState();
}

class _SinduHomeState extends State<SinduHome> {
  int _currentIndex = 0;
  List<Widget> _screenContainer = [
    SinduPlayer(),
    SinduFav(),
    SinduList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenContainer[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled_sharp),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_sharp),
            label: 'Songs',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
