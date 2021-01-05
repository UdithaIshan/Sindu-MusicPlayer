import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

List<XFile> files = files;
//
void _openFile(BuildContext context) async {
  final XTypeGroup mp3TypeGroup = XTypeGroup(
    label: 'MP3s',
    extensions: ['mp3'],
  );
  files = await openFiles(acceptedTypeGroups: [
    mp3TypeGroup,
  ]);
  await showDialog(
    context: context,
    builder: (context) => MultipleImagesDisplay(files),
  );
}

class _SongListState extends State<SongList> {
  @override
  Widget build(BuildContext context) {
       return Container(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             RaisedButton(
               color: Colors.blue,
               textColor: Colors.white,
               child: Text('Press to open multiple images (png, jpg)'),
               onPressed: () => _openFile(context),
             ),
           ],
         ),
       );
  }
}

class MultipleImagesDisplay extends StatelessWidget {
  /// The files containing the images
  final List<XFile> files;

  /// Default Constructor
  MultipleImagesDisplay(this.files);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Gallery'),
      // On web the filePath is a blob url
      // while on other platforms it is a system path.
      content: Center(
        child: Row(
          children: <Widget>[
            ...files.map(
                  (file) => Flexible(
                  child: Text(file.path)),
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class FileOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
