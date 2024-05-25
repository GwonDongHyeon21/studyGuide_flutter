// ignore_for_file: file_names, library_prefixes

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:studyguide_flutter/profile/my_profile.dart';

class YouTubeVideo {
  final String title;
  final String thumbnailUrl;
  final String viewCount;
  final String channelTitle;
  final String channelThumbnailUrl;

  YouTubeVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.viewCount,
    required this.channelTitle,
    required this.channelThumbnailUrl,
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
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        video.thumbnailUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'View: ${video.viewCount}',
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  // 여기에 터치 이벤트를 처리하여 원하는 동작을 수행합니다.
                                  // 예를 들어 다른 곳으로 이동하거나 특정 URL을 엽니다.
                                  // 여기서는 새로운 화면으로 이동하도록 하겠습니다.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyProfile()),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(video.channelThumbnailUrl),
                                  radius: 8,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  video.channelTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    ),
  );
  /*ElevatedButton(
          onPressed: () {
            // 버튼을 누를 때 실행되는 동작 정의
          },
          child: Text('버튼 텍스트'),
        ),*/
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
    final channelId = snippet['channelId'];

    final channelApiUrl =
        'https://www.googleapis.com/youtube/v3/channels?part=snippet&id=$channelId&key=$apiKey';
    final channelResponse = await http.get(Uri.parse(channelApiUrl));

    if (channelResponse.statusCode == 200) {
      final channelData = json.decode(channelResponse.body);
      final channelSnippet = channelData['items'][0]['snippet'];
      final channelTitle = channelSnippet['title'];
      final channelThumbnailUrl = channelSnippet['thumbnails']['high']['url'];

      final title = snippet['title'];
      final thumbnailUrl = snippet['thumbnails']['high']['url'];
      final viewCount = statistics['viewCount'];

      final formattedViewCount =
          NumberFormat('#,###').format(int.parse(viewCount));

      return YouTubeVideo(
        title: title,
        thumbnailUrl: thumbnailUrl,
        viewCount: formattedViewCount,
        channelTitle: channelTitle,
        channelThumbnailUrl: channelThumbnailUrl,
      );
    } else {
      throw Exception('Failed to load video details');
    }
  } else {
    throw Exception('Failed to load video details');
  }
}
