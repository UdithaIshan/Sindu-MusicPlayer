import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:play_me/models/playerData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeftSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 79.0,
        child: Container(
          color: Colors.grey.shade800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WindowTitleBarBox(child: Center(child: Text(''))),    // In here we can add a Window title
              ],
            )
        )
    );
  }
}

class RightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            color: Color(0xff303030),
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                WindowButtons()
              ])),
            ])
        )
    );
  }
}

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xffeb1555),
    iconMouseOver: Colors.white
);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: closeButtonColors),
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
