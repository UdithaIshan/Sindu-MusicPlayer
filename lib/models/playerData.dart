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

  void addFavourites(value) {
    this.favs.add(value);
    notifyListeners();
  }

  void removeFavourites(value) {
    this.favs.remove(value);
    notifyListeners();
  }

  void removeFavouritesByIndex(value) {
    this.favs.removeAt(value);
    notifyListeners();
  }

  void togglePlayFavourites(value) {
    this.playFavourites = value;
  }
}