// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:sindu_music_player/player/player.dart';
// import 'package:rxdart/rxdart.dart';
// import 'dart:math';
//
// class SinduPlayer extends StatefulWidget {
//   @override
//   _SinduPlayerState createState() => _SinduPlayerState();
// }
//
// enum Status { running, stopped, paused }
// IconData iconType = Icons.play_arrow_sharp;
// Status current = Status.running;
//
// void setIcon() {
//   if(current == Status.running){
//     iconType = Icons.pause;
//     current = Status.paused;
//   }
//   else if(current == Status.paused){
//     iconType = Icons.play_arrow_sharp;
//     current = Status.running;
//   }
// }
//
// class _SinduPlayerState extends State<SinduPlayer> {
//
//   final BehaviorSubject<double> _dragPositionSubject = BehaviorSubject.seeded(null);
//
//   final _queue = <MediaItem>[
//     MediaItem(
//       id: "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp33",
//       album: "Science Friday",
//       title: "From Cat Rheology To Operatic Incompetence",
//       artist: "Science Friday and WNYC Studios",
//       duration: Duration(milliseconds: 27252),
//       artUri:
//       "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
//     )
//   ];
//
//   bool _loading;
//
//   @override
//   void initState() {
//     super.initState();
//     _loading = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // return Scaffold(
//     //   body: Column(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       Row(
//     //         mainAxisAlignment: MainAxisAlignment.center,
//     //         children: [
//     //           GestureDetector(
//     //             onTap: () {},
//     //             child: Icon(
//     //                 Icons.skip_previous_sharp,
//     //                 size: 90.0,
//     //                 color: Colors.white
//     //             ),
//     //           ),
//     //           GestureDetector(
//     //             onTap: (){
//     //               setState(() {
//     //                 setIcon();
//     //               });
//     //             },
//     //             child: Icon(
//     //                 iconType,
//     //                 size: 90.0,
//     //                 color: Colors.white),
//     //           ),
//     //           GestureDetector(
//     //             onTap: () {},
//     //             child: Icon(
//     //                 Icons.skip_next_sharp,
//     //                 size: 90.0,
//     //                 color: Colors.white),
//     //           ),
//     //         ],
//     //       )
//     //     ],
//     //   ),
//     // );
//     return AudioServiceWidget(
//       child: Scaffold(
//         body:Container(
//           padding: EdgeInsets.all(20.0),
//           color: Colors.white,
//           child: StreamBuilder<AudioState>(
//             stream: _audioStateStream,
//             builder: (context, snapshot) {
//               final audioState = snapshot.data;
//               final queue = audioState?.queue;
//               final mediaItem = audioState?.mediaItem;
//               final playbackState = audioState?.playbackState;
//               final processingState =
//                   playbackState?.processingState ?? AudioProcessingState.none;
//               final playing = playbackState?.playing ?? false;
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     if (processingState == AudioProcessingState.none) ...[
//                       _startAudioPlayerBtn(),
//                     ] else ...[
//                       //positionIndicator(mediaItem, playbackState),
//                       SizedBox(height: 20),
//                       if (mediaItem?.title != null) Text(mediaItem.title),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           !playing
//                               ? IconButton(
//                             icon: Icon(Icons.play_arrow),
//                             iconSize: 64.0,
//                             onPressed: AudioService.play,
//                           )
//                               : IconButton(
//                             icon: Icon(Icons.pause),
//                             iconSize: 64.0,
//                             onPressed: AudioService.pause,
//                           ),
//                           // IconButton(
//                           //   icon: Icon(Icons.stop),
//                           //   iconSize: 64.0,
//                           //   onPressed: AudioService.stop,
//                           // ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.skip_previous),
//                                 iconSize: 64,
//                                 onPressed: () {
//                                   if (mediaItem == queue.first) {
//                                     return;
//                                   }
//                                   AudioService.skipToPrevious();
//                                 },
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.skip_next),
//                                 iconSize: 64,
//                                 onPressed: () {
//                                   if (mediaItem == queue.last) {
//                                     return;
//                                   }
//                                   AudioService.skipToNext();
//                                 },
//                               )
//                             ],
//                           ),
//                         ],
//                       )
//                     ]
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//
// _startAudioPlayerBtn() {
//   List<dynamic> list = List();
//   for (int i = 0; i < 1; i++) {
//     var m = _queue[i].toJson();
//     list.add(m);
//   }
//   var params = {"data": list};
//   return MaterialButton(
//     child: Text(_loading ? "Loading..." : 'Start Audio Player'),
//     onPressed: () async {
//       setState(() {
//         _loading = true;
//       });
//       await AudioService.start(
//         backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
//         androidNotificationChannelName: 'Audio Player',
//         androidNotificationColor: 0xFF2196f3,
//         androidNotificationIcon: 'mipmap/ic_launcher',
//         params: params,
//       );
//       setState(() {
//         _loading = false;
//       });
//     },
//   );
// }
//
// Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
//   double seekPos;
//   return StreamBuilder(
//     stream: Rx.combineLatest2<double, double, double>(
//         _dragPositionSubject.stream,
//         Stream.periodic(Duration(milliseconds: 200)),
//             (dragPosition, _) => dragPosition),
//     builder: (context, snapshot) {
//       double position =
//           snapshot.data ?? state.currentPosition.inMilliseconds.toDouble();
//       double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
//       return Column(
//         children: [
//           if (duration != null)
//             Slider(
//               min: 0.0,
//               max: duration,
//               value: seekPos ?? max(0.0, min(position, duration)),
//               onChanged: (value) {
//                 _dragPositionSubject.add(value);
//               },
//               onChangeEnd: (value) {
//                 AudioService.seekTo(Duration(milliseconds: value.toInt()));
//                 // Due to a delay in platform channel communication, there is
//                 // a brief moment after releasing the Slider thumb before the
//                 // new position is broadcast from the platform side. This
//                 // hack is to hold onto seekPos until the next state update
//                 // comes through.
//                 // TODO: Improve this code.
//                 seekPos = value;
//                 _dragPositionSubject.add(null);
//               },
//             ),
//           Text("${state.currentPosition}"),
//         ],
//       );
//     },
//   );
// }
// }
//
// Stream<AudioState> get _audioStateStream {
//   return Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, AudioState>(AudioService.queueStream, AudioService.currentMediaItemStream, AudioService.playbackStateStream, (queue, mediaItem, playbackState) => AudioState(queue, mediaItem, playbackState,),);
// }
//
// void _audioPlayerTaskEntrypoint() async {
//   AudioServiceBackground.run(() => SinduPlayerTask());
// }

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(SinduPlayer());

class SinduPlayer extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SinduPlayer> {
  AudioPlayer _player;
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: [
    LoopingAudioSource(
      count: 2,
      child: ClippingAudioSource(
        start: Duration(seconds: 60),
        end: Duration(seconds: 65),
        child: AudioSource.uri(Uri.parse(
            "https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3")),
        tag: AudioMetadata(
          album: "Science Friday",
          title: "A Salute To Head-Scratching Science (5 seconds)",
          artwork:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        ),
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.load(_playlist);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence?.isEmpty ?? true) return SizedBox();
                    final metadata = state.currentSource.tag as AudioMetadata;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Center(child: Image.network(metadata.artwork)),
                          ),
                        ),
                        Text(metadata.album ?? '',
                            style: Theme.of(context).textTheme.headline6),
                        Text(metadata.title ?? ''),
                      ],
                    );
                  },
                ),
              ),
              ControlButtons(_player),
              StreamBuilder<Duration>(
                stream: _player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      var position = snapshot.data ?? Duration.zero;
                      if (position > duration) {
                        position = duration;
                      }
                      return SeekBar(
                        duration: duration,
                        position: position,
                        onChangeEnd: (newPosition) {
                          _player.seek(newPosition);
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.orange),
                        Icon(Icons.repeat_one, color: Colors.orange),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                          (cycleModes.indexOf(loopMode) + 1) %
                              cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Playlist",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: Colors.orange)
                            : Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () {
                          _player.setShuffleModeEnabled(!shuffleModeEnabled);
                        },
                      );
                    },
                  ),
                ],
              ),
              Container(
                height: 240.0,
                child: StreamBuilder<SequenceState>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final sequence = state?.sequence ?? [];
                    return ListView.builder(
                      itemCount: sequence.length,
                      itemBuilder: (context, index) => Material(
                        color: index == state.currentIndex
                            ? Colors.grey.shade300
                            : null,
                        child: ListTile(
                          title: Text(sequence[index].tag.title),
                          onTap: () {
                            _player.seek(Duration.zero, index: index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return AudioServiceWidget(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust volume",
                divisions: 10,
                min: 0.0,
                max: 1.0,
                stream: player.volumeStream,
                onChanged: player.setVolume,
              );
            },
          ),
          StreamBuilder<SequenceState>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: player.hasPrevious ? player.seekToPrevious : null,
            ),
          ),
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => player.seek(Duration.zero, index: 0),
                );
              }
            },
          ),
          StreamBuilder<SequenceState>(
            stream: player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: player.hasNext ? player.seekToNext : null,
            ),
          ),
          StreamBuilder<double>(
            stream: player.speedStream,
            builder: (context, snapshot) => IconButton(
              icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                _showSliderDialog(
                  context: context,
                  title: "Adjust speed",
                  divisions: 10,
                  min: 0.5,
                  max: 1.5,
                  stream: player.speedStream,
                  onChanged: player.setSpeed,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch("$_remaining")
                  ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}