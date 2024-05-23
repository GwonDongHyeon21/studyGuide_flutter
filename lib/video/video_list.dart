import 'package:flutter/material.dart';
import 'package:studyguide_flutter/url/video_url.dart';
import 'package:studyguide_flutter/video/video_search_subject.dart';
import 'package:studyguide_flutter/url/video_parse.dart';

class VideoList extends StatelessWidget {
  const VideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Links',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoListPage(
        subject: '',
      ),
    );
  }
}

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key, required this.subject});
  final String subject;

  @override
  // ignore: library_private_types_in_public_api
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<String> videoUrls = [];
  final int _currentMax = 8;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadMoreVideos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreVideos() {
    final allVideos = subjectVideoUrls[widget.subject] ?? [];
    setState(() {
      videoUrls.addAll(allVideos.skip(videoUrls.length).take(_currentMax));
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: '과목 내에서 검색',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
                onSubmitted: (String query) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoSearchSubjectPage(
                          subject: widget.subject, searchQuery: query),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            '${widget.subject} 영상',
            style: const TextStyle(fontSize: 20),
          ),
          Expanded(
            child: GridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              children: videoUrls.map((url) => buildLinkItem(url)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
