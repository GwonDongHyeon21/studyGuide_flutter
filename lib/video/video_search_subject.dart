import 'package:flutter/material.dart';
import 'package:studyguide_flutter/url/video_url_list.dart';
import 'package:studyguide_flutter/url/video_parse.dart';
import 'package:studyguide_flutter/url/video_url.dart';

class VideoSearchSubject extends StatelessWidget {
  const VideoSearchSubject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'videoSearch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoSearchSubjectPage(subject: '', searchQuery: ''),
    );
  }
}

class VideoSearchSubjectPage extends StatelessWidget {
  const VideoSearchSubjectPage(
      {Key? key, required this.subject, required this.searchQuery})
      : super(key: key);
  final String searchQuery;
  final String subject;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchedQueary =
        TextEditingController(text: searchQuery);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 35, bottom: 20, left: 5, right: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: searchedQueary,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
                onSubmitted: (String query) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoSearchSubjectPage(
                          searchQuery: query, subject: subject),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _filterVideos(searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No videos found'));
                } else {
                  final filteredVideos = snapshot.data!;
                  return GridView.count(
                    crossAxisCount: 2,
                    children: filteredVideos
                        .map((url) => buildLinkItem(url))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _filterVideos(String query) async {
    List<String> filteredUrls = [];

    final urls = subjectVideoUrls[subject] ?? [];

    for (var url in urls) {
      try {
        final videoDetails = await fetchVideoDetails(url);
        if (videoDetails.title.contains(query)) {
          filteredUrls.add(url);
        }
      } catch (e) {
        //next url
      }
    }
    return filteredUrls;
  }
}
