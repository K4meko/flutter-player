// models/now_playing_model.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class NowPlayingModel extends ChangeNotifier {
  final player = AudioPlayer();
  Song? nowPlaying;
  bool isPlaying = false;
  void stop() {
    isPlaying = false;
    player.pause();
    notifyListeners();
  }

  Future<void> initialize() async {
    // Set up audio session
    try {
      await player.setReleaseMode(ReleaseMode.release);
      print("Audio player initialized");
    } catch (e) {
      print("Error initializing audio player: $e");
    }
  }

  void play() {
    isPlaying = true;
    player.resume();
    notifyListeners();
  }

  Future<void> setNowPlaying(Song song) async {
    try {
      await player.stop();
      await player.play(DeviceFileSource(song.path));
      nowPlaying = song;
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("Error playing audio: $e");

      try {
        await Future.delayed(const Duration(milliseconds: 500));
        await player.play(DeviceFileSource(song.path));
        print("Audio playback started on second attempt");

        nowPlaying = song;
        isPlaying = true;
        notifyListeners();
      } catch (e) {
        print("Failed on second attempt: $e");
      }
    }
  }
}

class Song {
  final String title;
  final String artist;
  final String album;
  final String path;
  final Uint8List? albumArt;

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.path,
    this.albumArt,
  });
}
