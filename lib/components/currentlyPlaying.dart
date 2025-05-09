// components/currentlyPlaying.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/models/now_playing_model.dart';

class Currentlyplaying extends StatelessWidget {
  const Currentlyplaying({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NowPlayingModel>(
      builder: (context, nowPlayingModel, child) {
        return Container(
          padding: const EdgeInsets.all(5),
          color: Theme.of(context).colorScheme.primaryContainer,
          width: double.maxFinite,
          child: Row(
            children: [
              if (nowPlayingModel.nowPlaying?.albumArt != null)
                Image.memory(
                  nowPlayingModel.nowPlaying!.albumArt!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey,
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              const SizedBox(width: 10),
              Expanded(
                flex: 9,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  height: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nowPlayingModel.nowPlaying?.title ?? "No Song",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.01,
                        ),
                      ),
                      Text(
                        nowPlayingModel.nowPlaying?.artist ?? "Unknown Artist",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                iconSize: 40,
                icon:
                    nowPlayingModel.isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                onPressed: () {
                  if (nowPlayingModel.isPlaying) {
                    nowPlayingModel.stop();
                  } else {
                    nowPlayingModel.play();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
