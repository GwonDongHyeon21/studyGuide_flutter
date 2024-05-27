import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyProfilePage(),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyProfilePage createState() => _MyProfilePage();
}

class _MyProfilePage extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {

    final List<String> watchHistory = [
      'Video 1',
      'Video 2',
      'Video 3',
      'Video 4',
      'Video 5',
      'Video 6',
      'Video 7',
      'Video 8',
      'Video 9',
      'Video 10',
    ];

    File? image;
    final picker = ImagePicker();

    Future getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {}
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 프로필'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: getImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  if(image == null)
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '좋아요 영상',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: watchHistory.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 160,
                    child: Card(
                      child: Center(
                        child: Text(watchHistory[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '좋아요 강사',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: watchHistory.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 160,
                    child: Card(
                      child: Center(
                        child: Text(watchHistory[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
