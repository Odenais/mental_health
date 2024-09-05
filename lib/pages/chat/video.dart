import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health/pages/chat/chat.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

const apiKey = "AIzaSyCXK2RQrewEWvnzyw2j_5GOc8411V9GIiM";

Future<Map<String, String?>> searchYoutubeVideo(String query) async {
  final url =
      'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['items'].isNotEmpty) {
      final videoId = data['items'][0]['id']['videoId'];
      final title = data['items'][0]['snippet']['title'];
      final thumbnailUrl =
          data['items'][0]['snippet']['thumbnails']['high']['url'];
      return {
        'videoId': videoId,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
      };
    }
  }
  return {'videoId': null, 'title': null, 'thumbnailUrl': null};
}

class AudioPlayerComponent extends StatefulWidget {
  final String query;

  const AudioPlayerComponent({Key? key, required this.query}) : super(key: key);

  @override
  _AudioPlayerComponentState createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isLoading = true;
  String _videoId = ''; // Valor por defecto
  String _title = '';
  String _thumbnailUrl = '';
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _audioPlayer.playingStream.listen((isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    });
  }

  Future<void> _initializePlayer() async {
    final youtube = YoutubeExplode();
    final data = await searchYoutubeVideo(widget.query);

    if (data['videoId'] != null) {
      setState(() {
        _videoId = data['videoId']!;
        _title = data['title']!;
        _thumbnailUrl = data['thumbnailUrl']!;
      });

      final video = youtube.videos.get(_videoId);
      final manifest = await youtube.videos.streamsClient.getManifest(_videoId);
      final audioStream = manifest.audioOnly.first;

      // Detener el audio actual si está en reproducción
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      // Configurar la nueva fuente de audio y reproducir
      await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(audioStream.url.toString())));
      _audioPlayer.play();

      setState(() {
        isLoading = false;
      });
    } else {
      print('No results found');
      setState(() {
        isLoading = false;
      });
    }
  }

  void stopAudio() async {
    await _audioPlayer.stop();
  }

  void pauseAudio() async {
    await _audioPlayer.pause();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pauseAudio();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Mostrar el título y la miniatura
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              constraints: BoxConstraints(maxHeight: 130),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Centra verticalmente
                crossAxisAlignment: CrossAxisAlignment.start,
                // Alinea a la izquierda
                children: [
                  if (_thumbnailUrl.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        // Borde redondeado
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 8.0)
                        ], // Sombra opcional
                      ),
                      clipBehavior: Clip.hardEdge,
                      // Asegura que la imagen se ajuste al borde redondeado
                      child: Image.network(
                        _thumbnailUrl,
                        width: 180,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            )),
            SizedBox(width: 16),
            Expanded(
                child: Column(
              children: [
                if (_title.isNotEmpty)
                  Text(
                    "🎶 " + _title,
                    style: TextStyle(fontSize: 16),
                    // Añade puntos suspensivos si el texto es demasiado largo
                    softWrap: true,
                  ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromARGB(255, 170, 149, 208),
                      child: IconButton(
                        color: Colors.black,
                        iconSize: 25,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: togglePlayPause,
                      ),
                    ),
                    SizedBox(width: 16),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.redAccent,
                      child: IconButton(
                        iconSize: 25,
                        color: Colors.black,
                        icon: Icon(Icons.stop),
                        onPressed: stopAudio,
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
