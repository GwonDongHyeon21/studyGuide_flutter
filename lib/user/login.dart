// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:studyguide_flutter/user/signup.dart';
import 'package:studyguide_flutter/video/video_subject.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // ignore: unused_field
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'Id'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              //onPressed: _logIn,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VideoSubjectPage()))
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("User signed in: ${userCredential.user}");
      setState(() {
        _errorMessage = '';
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoSubjectPage()),
      );
    } on FirebaseAuthException catch (e) {
      print("Failed to sign in: $e");
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
    } catch (e) {
      print("Failed to sign in: $e");
      setState(() {
        _errorMessage = 'An error occurred, please try again later.';
      });
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return '사용자가 존재하지 않습니다.';
      case 'wrong-password':
        return '비밀번호를 확인하세요';
      case 'invalid-email':
        return '이메일을 확인하세요.';
      default:
        return 'An error occurred, please try again later.';
    }
  }
}
