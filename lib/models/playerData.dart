import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';

class PlayerData extends ChangeNotifier {
  PlayerData() {
    this.player = Player(id: 0);
  }

  List<Media> medias = <Media>[];
  List<Media> favs = <Media>[];
  bool playFavourites = false;
  Player player;

  // add files to favourite list
  void addFavourites(value) {
    this.favs.add(value);
    notifyListeners();
  }

  // remove files from favourite list
  void removeFavourites(value) {
    this.favs.remove(value);
    notifyListeners();
  }

  // remove files from favourite list using index
  void removeFavouritesByIndex(index) {
    this.favs.removeAt(index);
    notifyListeners();
  }

  // set whether player is playing in favourites list or not
  void togglePlayFavourites(value) {
    this.playFavourites = value;
  }
}