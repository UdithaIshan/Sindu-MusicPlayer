import 'dart:convert';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class PlayerData extends ChangeNotifier {
  List<Media> medias = <Media>[];
  List<Media> favs = <Media>[];
  bool playFavourites = false;
  var metas;
  Media singlePlay;

  // void _openMediaFile(BuildContext context, medias) async {
  //   final mp3TypeGroup = XTypeGroup(
  //     label: 'MP3s',
  //     extensions: ['mp3'],
  //   );
  //   final files = await FileSelectorPlatform.instance.openFiles(acceptedTypeGroups: [
  //     mp3TypeGroup,
  //   ]);
  //
  //   if (files.isNotEmpty) {
  //     medias.clear();
  //
  //     await Future.forEach(files, (item) async {
  //       medias.add(await Media.file(new File(item.path)));
  //     });
  //
  //     // await Future.forEach(medias, (item) async {
  //     //   await player.add(item);
  //     // });
  //
  //     context.setState(() {});
  //   }
  // }

  void getMetas(Player player) async {
    try {

      Media metasMedia = await Media.file(
          new File(this.playFavourites ? this.favs[player.current.index].resource : this.medias[player.current.index].resource),
          parse: true);
      print('in meta ${player.current.index}');
      var jsonString =
      JsonEncoder.withIndent('    ').convert(metasMedia?.metas);
      this.metas = json.decode(jsonString);
      print(this.metas['artworkUrl']);
      // setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<String> getNameOfThis(Media media) async {
    try {
      Media metaMedia = await Media.file(new File(media.resource), parse: true);
      var jsonString = JsonEncoder.withIndent('    ').convert(metaMedia?.metas);
      var meta = json.decode(jsonString);
      return meta != null ? meta['title'] : '';
    } catch (e) {
      return "Can't get the data 💔";
    }
  }

  String getDurationFormatted(int seconds) {
    if(seconds % 60 == 0) {
      int minutes = seconds ~/ 60;
      return '$minutes:00';
    }
    else {
      int remainder = seconds % 60;
      int value = seconds ~/ 60;
      return '$value:${remainder > 9 ? remainder : '0$remainder'}';
    }
  }

  void addFavourites(value) {
    this.favs.add(value);
    notifyListeners();
  }

  void removeFavourites(index) {
    this.favs.removeAt(index);
    notifyListeners();
  }

  void addSinglePlay(value) {
    this.singlePlay = value;
    notifyListeners();
  }

  void togglePlayFavourites(value) {
    this.playFavourites = value;
  }
}