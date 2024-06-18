// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studyguide_flutter/api/firebase_settings.dart';
import 'package:studyguide_flutter/user/login.dart';
import 'package:studyguide_flutter/video/video_subject.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: MyFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppPage createState() => _MyAppPage();
}

class _MyAppPage extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '로그인 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? account;
  bool _isLoading = true;
  String email = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    try {
      final account = await googleSignIn.signInSilently();
      if (account != null) {
        setState(() {
          email = account.email;
          id = account.displayName!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (account != null) {
      return VideoSubjectPage(
        email: email,
        id: id,
      );
    } else {
      return const LoginPage();
    }
  }
}
