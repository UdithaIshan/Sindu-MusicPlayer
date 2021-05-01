import 'dart:convert';
import 'package:dart_vlc/dart_vlc.dart';
import 'dart:io';

class Core {

  static Future<String> getNameOfThis(Media media) async {
    try {
      Media metaMedia = await Media.file(new File(media.resource), parse: true);
      var jsonString = JsonEncoder.withIndent('    ').convert(metaMedia?.metas);
      var meta = json.decode(jsonString);
      return meta != null ? meta['title'] : '';
    } catch (e) {
      return "Can't get the data 💔";
    }
  }

  static String getDurationFormatted(int seconds) {
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
}