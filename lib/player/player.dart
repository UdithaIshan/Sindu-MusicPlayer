import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

MediaControl play  = MediaControl(androidIcon: 'drawable/play', label: 'play', action: MediaAction.play);
MediaControl pause = MediaControl(androidIcon: 'drawable/pause', label: 'pause', action: MediaAction.pause);
MediaControl next = MediaControl(androidIcon: 'drawable/next', label: 'next', action: MediaAction.skipToNext);
MediaControl previous = MediaControl(androidIcon: 'drawable/previous', label: 'previous', action: MediaAction.skipToPrevious);
MediaControl stop = MediaControl(androidIcon: 'drawable/stop', label: 'stop', action: MediaAction.stop);

class SinduPlayerTask extends BackgroundAudioTask {

  var _queue = <MediaItem>[];
  int _queueIndex = -1;
  AudioPlayer _sinduPlayer = new AudioPlayer();
  AudioProcessingState _skipState;
  bool _playing;
  bool get hasNext => _queueIndex + 1 < _queue.length;
  bool get hasPrevious => _queueIndex > 0;
  MediaItem get mediaItem =>    _queue[_queueIndex];
  StreamSubscription<AudioPlaybackState> _playerStateSubscription;
  StreamSubscription<AudioPlaybackEvent> _eventSubscription;
  @override
  void onStart(Map<String, dynamic> params) {
    _queue.clear();
    List mediaItems = params['data'];
    for (int i = 0; i < mediaItems.length; i++) {
      MediaItem mediaItem = MediaItem.fromJson(mediaItems[i]);
      _queue.add(mediaItem);
    }
    _playerStateSubscription = _sinduPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });
    _eventSubscription = _sinduPlayer.playbackEventStream.listen((event) {
      final bufferingState =
      event.buffering ? AudioProcessingState.buffering : null;
      switch (event.state) {
        case AudioPlaybackState.paused:
          _setState(
              processingState: bufferingState ?? AudioProcessingState.ready,
              position: event.position);
          break;
        case AudioPlaybackState.playing:
          _setState(
              processingState: bufferingState ?? AudioProcessingState.ready,
              position: event.position);
          break;
        case AudioPlaybackState.connecting:
          _setState(
              processingState: _skipState ?? AudioProcessingState.connecting,
              position: event.position);
          break;
        default:
      }
    });
    AudioServiceBackground.setQueue(_queue);
    onSkipToNext();
  }
  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _sinduPlayer.play();
    }
  }
  @override
  void onPause() {
    _playing = false;
    _sinduPlayer.pause();
  }
  @override
  void onSkipToNext() async {
    skip(1);
  }
  @override
  void onSkipToPrevious() {
    skip(-1);
  }void skip(int offset) async {
    int newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) {
      return;
    }
    if (null == _playing) {
      _playing = true;
    } else if (_playing) {
      await _sinduPlayer.stop();
    }
    _queueIndex = newPos;
    _skipState = offset > 0
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    AudioServiceBackground.setMediaItem(mediaItem);
    await _sinduPlayer.setUrl(mediaItem.id);
    print(mediaItem.id);
    _skipState = null;
    if (_playing) {
      onPlay();
    } else {
      _setState(processingState: AudioProcessingState.ready);
    }
  }
  @override
  Future<void> onStop() async {
    _playing = false;
    await _sinduPlayer.stop();
    await _sinduPlayer.dispose();
    _playerStateSubscription.cancel();
    _eventSubscription.cancel();
    return await super.onStop();
  }
  @override
  void onSeekTo(Duration position) {
    _sinduPlayer.seek(position);
  }
  @override
  void onClick(MediaButton button) {
    playPause();
  }
  @override
  Future<void> onFastForward() async {
    await _seekRelative(fastForwardInterval);
  }
  @override
  Future<void> onRewind() async {
    await _seekRelative(rewindInterval);
  }Future<void> _seekRelative(Duration offset) async {
    var newPosition = _sinduPlayer.playbackEvent.position + offset;
    if (newPosition < Duration.zero) {
      newPosition = Duration.zero;
    }
    if (newPosition > mediaItem.duration) {
      newPosition = mediaItem.duration;
    }
    await _sinduPlayer.seek(_sinduPlayer.playbackEvent.position + offset);
  }_handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }void playPause() {
    if (AudioServiceBackground.state.playing)
      onPause();
    else
      onPlay();
  }Future<void> _setState({
    AudioProcessingState processingState,
    Duration position,
    Duration bufferedPosition,
  }) async {
    print('SetState $processingState');
    if (position == null) {
      position = _sinduPlayer.playbackEvent.position;
    }
    await AudioServiceBackground.setState(
      controls: getControls(),
      systemActions: [MediaAction.seekTo],
      processingState:
      processingState ?? AudioServiceBackground.state.processingState,
      playing: _playing,
      position: position,
      bufferedPosition: bufferedPosition ?? position,
      speed: _sinduPlayer.speed,
    );
  }List<MediaControl> getControls() {
    if (_playing) {
      return [
        previous,
        pause,
        stop,
        next
      ];
    } else {
      return [
        previous,
        play,
        stop,
        next
      ];
    }
  }
}

class AudioState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;
  final PlaybackState playbackState;AudioState(this.queue, this.mediaItem, this.playbackState);
}