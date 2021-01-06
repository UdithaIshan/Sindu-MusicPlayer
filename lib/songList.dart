import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {

  List<XFile> _files = [];

  Future <List<XFile>> _openFile(BuildContext context) async {
    // List<XFile> files = [];
    final XTypeGroup mp3TypeGroup = XTypeGroup(
      label: 'MP3s',
      extensions: ['mp3'],
    );
    var _newFiles = await openFiles(acceptedTypeGroups: [
      mp3TypeGroup,
    ]);
    setState(() {
      _files = _newFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Open your songs list'),
            onPressed: () {
              _openFile(context);
            }
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: (context, index) {
              return Text(_files[index].path);
            },
          ),
        ),
      ],
    );
  }
}
