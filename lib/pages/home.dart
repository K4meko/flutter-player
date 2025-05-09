// pages/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart'; // Import Provider
import 'package:untitled1/models/now_playing_model.dart';
import 'package:untitled1/models/settings_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Song>> _getFilesInDownloadsDirectory(
    SettingsModel settingsModel,
  ) async {
    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      return [];
    }

    final files = downloadsDir.listSync();
    List<Song> songs = [];

    for (var file in files.whereType<File>()) {
      try {
        final metadata = await MetadataRetriever.fromFile(file);
        if (settingsModel.downloadAlbumArtwork) {
          songs.add(
            Song(
              title:
                  metadata.trackName ?? p.basenameWithoutExtension(file.path),
              artist: metadata.authorName ?? "Unknown Artist",
              album: metadata.albumName ?? "Unknown Album",
              path: file.path,
              albumArt: metadata.albumArt,
            ),
          );
        } else {
          songs.add(
            Song(
              title:
                  metadata.trackName ?? p.basenameWithoutExtension(file.path),
              artist: metadata.authorName ?? "Unknown Artist",
              album: metadata.albumName ?? "Unknown Album",
              path: file.path,
              albumArt: null,
            ),
          );
        }
      } catch (e) {
        print("Error fetching metadata for ${file.path}: $e");
      }
    }
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context, listen: true);

    final nowPlayingModel = Provider.of<NowPlayingModel>(
      context,
      listen: false,
    ); // Access the existing instance

    return Scaffold(
      appBar: AppBar(title: const Text("Downloads Directory")),
      body: FutureBuilder<List<Song>>(
        future: _getFilesInDownloadsDirectory(settingsModel),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No files found"));
          } else {
            return ListView(
              children:
                  snapshot.data!.map((files) {
                    return ListTile(
                      title: Text(files.title),
                      onTap: () {
                        try {
                          nowPlayingModel.setNowPlaying(files);
                        } catch (e) {
                          print("Error playing file: $e");
                        }
                      },
                    );
                  }).toList(),
            );
          }
        },
      ),
    );
  }
}
