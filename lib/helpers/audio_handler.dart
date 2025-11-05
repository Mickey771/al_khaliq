import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final player = AudioPlayer();

  MyAudioHandler() {
    _init();
  }

  @override
  Future<void> play() async {
    print(">>> PLAY triggered");
    await player.play();
  }

  @override
  Future<void> pause() async {
    print(">>> PAUSE triggered");
    await player.pause();
  }

  @override
  Future<void> stop() => player.stop();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToNext() => player.seekToNext();

  @override
  Future<void> skipToPrevious() => player.seekToPrevious();

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    queue.add(newQueue); // updates the stream
    final audioSources =
        newQueue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList();
    await player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: 0,
    );
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    player.playbackEventStream.listen((event) {
      playbackState.add(_transformEvent(event));
    });

    player.currentIndexStream.listen((index) {
      if (index != null && queue.value.length > index) {
        mediaItem.add(queue.value[index]);
      }
    });

    player.sequenceStateStream.listen((state) {
      if (state?.sequence != null) {
        // Update media item if needed
      }
    });
  }

  Future<void> loadAndPlay(MediaItem item) async {
    final index = queue.value.indexWhere((q) => q.id == item.id);
    if (index != -1) {
      final audioSources = queue.value
          .map((item) => AudioSource.uri(Uri.parse(item.id)))
          .toList();
      mediaItem.add(item); // Sync media item for notification
      await player.seek(Duration.zero, index: index);
      await player.setAudioSource(
          ConcatenatingAudioSource(children: audioSources),
          initialIndex: index);
      await player.play();
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      androidCompactActionIndices: [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      repeatMode: const {
        LoopMode.off: AudioServiceRepeatMode.none,
        LoopMode.one: AudioServiceRepeatMode.one,
        LoopMode.all: AudioServiceRepeatMode.all,
      }[player.loopMode]!,
      shuffleMode: (player.shuffleModeEnabled)
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
      systemActions: const {
        MediaAction.seek,
        MediaAction.stop,
        MediaAction.play,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
    );
  }
}
