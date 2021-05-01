import 'package:flutter/material.dart';
import 'package:play_me/utils/core.dart';
import 'package:provider/provider.dart';
import 'package:play_me/models/playerData.dart';

class StatefulListTile extends StatefulWidget {
  StatefulListTile({this.index});

  final int index;

  @override
  _StatefulListTileState createState() => _StatefulListTileState();
}

class _StatefulListTileState extends State<StatefulListTile> {
  @override
  Widget build(BuildContext context) {
    var playerData = context.watch<PlayerData>();

    return new Container(
      decoration: new BoxDecoration(
        border: new Border.all(width: 1.0, color: Colors.grey),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            playerData.favs.contains(playerData.medias[widget?.index])
                ? Icons.favorite
                : Icons.favorite_outline,
            color: Colors.redAccent,
          ),
          splashRadius: 20,
          onPressed: () {
            if (playerData.favs.contains(playerData.medias[widget?.index])) {
              playerData.removeFavourites(playerData.medias[widget?.index]);
            } else {
              playerData.addFavourites(playerData.medias[widget?.index]);
            }
          },
        ),
        title: FutureBuilder(
            future: Core.getNameOfThis(playerData.medias[widget.index]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data);
              }
              return Text('snapshot.data');
            }),

        //ToDo:
        // trailing: new IconButton(
        //   icon: Icon(Icons.play_circle_fill_rounded),
        //   onPressed: () {
        //     print('in listTile ${widget.index}');
        //     playerData.togglePlayFavourites(false);
        //     playerData.player.stop();
        //     playerData.player.open((playerData.medias[widget.index]), autoStart: true);
        //
        //   },
        // ),
      ),
    );
  }
}
