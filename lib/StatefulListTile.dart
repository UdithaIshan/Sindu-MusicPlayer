import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class StatefulListTile extends StatefulWidget {
  const StatefulListTile(
      {this.title, this.player, this.favs, this.medias, this.index, this.subtitle = ''});
  final String subtitle, title;
  final List<Media> medias;
  final List<Media> favs;
  final int index;
  final Player player;

  @override
  _StatefulListTileState createState() => _StatefulListTileState();
}

class _StatefulListTileState extends State<StatefulListTile> {
  Color _iconColor = Colors.white;
  IconData _icon = Icons.favorite_outline;
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Colors.grey),
      ),
      child: new ListTile(
        leading: new IconButton(
          icon: Icon(_icon),
          onPressed: () {
            if (widget?.favs.contains(widget?.medias[widget?.index])) {
              widget?.favs.remove(widget?.medias[widget?.index]);
              setState(() {
                _icon = _icon == Icons.favorite_outline
                    ? Icons.favorite
                    : Icons.favorite_outline;
              });
            } else {
              widget?.favs.add(widget?.medias[widget?.index]);
              setState(() {
                _icon = _icon == Icons.favorite_outline
                    ? Icons.favorite
                    : Icons.favorite_outline;
              });
            }
          },
        ),
        title: new Text(
          widget?.title ?? "",
          style: new TextStyle(
              fontWeight: FontWeight.bold, color: Colors.lightGreen),
          textAlign: TextAlign.right,
        ),
        trailing: new IconButton(
          icon: Icon(Icons.play_circle_fill_rounded),
          onPressed: () {
            print(widget.medias);
            // widget.player.jump(widget.index);
            widget.player.open(widget.medias[widget.index], autoStart: true);
          },
        ),
        // subtitle: new Text(widget?.subtitle ?? "",
        //     textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
        // isThreeLine: true,
      ),
    );
  }
}

// import 'package:dart_vlc/dart_vlc.dart';
// import 'package:flutter/material.dart';
//
// class StatefulListTile extends StatefulWidget {
//   const StatefulListTile(
//       {this.title, this.player, this.favs, this.medias, this.index, this.subtitle = ''});
//   final String subtitle, title;
//   final List<Media> medias;
//   final List<Media> favs;
//   final int index;
//   final Player player;
//
//   @override
//   _StatefulListTileState createState() => _StatefulListTileState();
// }
//
// class _StatefulListTileState extends State<StatefulListTile> {
//   Color _iconColor = Colors.white;
//   IconData _icon = Icons.favorite_outline;
//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       decoration: new BoxDecoration(
//         border: new Border.all(width: 1.0, color: Colors.grey),
//       ),
//       child: new ListTile(
//         leading: new IconButton(
//           icon: Icon(_icon),
//           onPressed: () {
//             if (widget?.favs.contains(widget?.medias[widget?.index])) {
//               widget?.favs.remove(widget?.medias[widget?.index]);
//               setState(() {
//                 _icon = _icon == Icons.favorite_outline
//                     ? Icons.favorite
//                     : Icons.favorite_outline;
//               });
//             } else {
//               widget?.favs.add(widget?.medias[widget?.index]);
//               setState(() {
//                 _icon = _icon == Icons.favorite_outline
//                     ? Icons.favorite
//                     : Icons.favorite_outline;
//               });
//             }
//           },
//         ),
//         title: new Text(
//           widget?.title ?? "",
//           style: new TextStyle(
//               fontWeight: FontWeight.bold, color: Colors.lightGreen),
//           textAlign: TextAlign.right,
//         ),
//         trailing: new IconButton(
//           icon: Icon(Icons.play_circle_fill_rounded),
//           onPressed: () {
//             print(widget.medias);
//             widget.player.jump(widget.index);
//             // widget.player.open(widget.medias[widget.index], autoStart: true);
//           },
//         ),
//         // subtitle: new Text(widget?.subtitle ?? "",
//         //     textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
//         // isThreeLine: true,
//       ),
//     );
//   }
// }

