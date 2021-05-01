import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:play_me/models/playerData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const sidebarColor = Color(0xff38616d);

class LeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundStartColor, backgroundEndColor],
                  stops: [0.0, 1.0]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WindowTitleBarBox(child: Center(child: Text('PlayMe Music Player', ))),
              ],
            )));
  }
}

const backgroundStartColor = Color(0xFF6c939f);
const backgroundEndColor = Color(0xFF00296f);
// const backgroundStartColor = Colors.grey;
// const backgroundEndColor = Colors.white;

class RightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundStartColor, backgroundEndColor],
                  stops: [0.0, 1.0]),
            ),
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                WindowButtons()
              ])),
            ])));
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFFF6A00C),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Color(0xFF805306),
    iconMouseDown: Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: closeButtonColors,
          onPressed: () async {
            List<String> favouriteMediaPaths = <String>[];
            Provider.of<PlayerData>(context, listen: false)
                .favs
                .forEach((element) {
              favouriteMediaPaths.add(element.resource);
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setStringList('favourites', favouriteMediaPaths);
            appWindow.close();
          },
        ),
      ],
    );
  }
}
