import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class ListTest extends StatefulWidget {
  @override
  _ListTestState createState() => _ListTestState();
}

class _ListTestState extends State<ListTest> {

  List<XFile> _files = [];

  Future <List<XFile>> _openFile(BuildContext context) async {
    // List<XFile> files = [];
    final XTypeGroup mp3TypeGroup = XTypeGroup(
      label: 'MP3s',
      extensions: ['mp3'],
    );
    _files = await openFiles(acceptedTypeGroups: [
      mp3TypeGroup,
    ]);
    // return files;
  }

  // @override
  // void initState() {
  //   _setup();
  //   super.initState();
  // }
  //
  // _setup() async {
  //   // Retrieve the questions (Processed in the background)
  //   List<XFile> files = await _openFile(context);
  //
  //   // Notify the UI and display the questions
  //   setState(() {
  //     _files = files;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Press to open multiple images (png, jpg)'),
          onPressed: () {
            setState(() {
              _openFile(context);
            });
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
