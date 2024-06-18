import 'package:flutter/material.dart';
import 'package:studyguide_flutter/video/video_list_build.dart';

class CreatorVideoList extends StatelessWidget {
  const CreatorVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creator Video Links List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreatorVideoListPage(
        email: '',
        urlCreator: '',
        creatorVideos: [],
      ),
    );
  }
}

class CreatorVideoListPage extends StatefulWidget {
  const CreatorVideoListPage({
    super.key,
    required this.email,
    required this.urlCreator,
    required this.creatorVideos,
  });

  final String email;
  final String urlCreator;
  final List<String> creatorVideos;

  @override
  // ignore: library_private_types_in_public_api
  _CreatorVideoListPage createState() => _CreatorVideoListPage();
}

class _CreatorVideoListPage extends State<CreatorVideoListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나중에 볼 동영상'),
        backgroundColor: const Color.fromARGB(255, 80, 180, 220),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.creatorVideos.isEmpty
                ? const Center(
                    child: Text('비어있습니다'),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: widget.creatorVideos.length,
                    itemBuilder: (context, index) {
                      return buildLinkItem(
                        widget.creatorVideos[index],
                        widget.urlCreator,
                        widget.email,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
