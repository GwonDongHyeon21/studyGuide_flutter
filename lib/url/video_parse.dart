// ignore_for_file: file_names, library_prefixes

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:http/http.dart' as http;

class YouTubeVideo {
  final String title;
  final String thumbnailUrl;
  final String viewCount;

  YouTubeVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.viewCount,
  });
}

Widget buildLinkItem(String videoUrl) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Link(
      uri: Uri.parse(videoUrl),
      builder: (BuildContext ctx, FollowLink? openLink) {
        return FutureBuilder<YouTubeVideo>(
          future: fetchVideoDetails(videoUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final video = snapshot.data!;
              return InkWell(
                onTap: openLink,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      video.thumbnailUrl,
                      width: double.infinity,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'View: ${video.viewCount}',
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                ),
              );
            }
          },
        );
      },
    ),
  );
}

Future<YouTubeVideo> fetchVideoDetails(String videoUrl) async {
  final videoId = videoUrl.split('v=')[1];
  const apiKey = 'AIzaSyCpJIzIv27HzCXJ-Gr7xDyia3N5s-jFaIw';
  final apiUrl =
      'https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&id=$videoId&key=$apiKey';
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final snippet = data['items'][0]['snippet'];
    final statistics = data['items'][0]['statistics'];
    final title = snippet['title'];
    final thumbnailUrl = snippet['thumbnails']['high']['url'];
    final viewCount = statistics['viewCount'];

    return YouTubeVideo(
      title: title,
      thumbnailUrl: thumbnailUrl,
      viewCount: viewCount,
    );
  } else {
    throw Exception('Failed to load video details');
  }
}
