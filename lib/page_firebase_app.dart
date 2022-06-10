import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_mp3/authentication/login_page.dart';
import 'package:my_mp3/page_home.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

// adb kill-server
// adb start-server

class MyFirebaseApp extends StatefulWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);

  @override
  State<MyFirebaseApp> createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  bool ketnoi = false;
  bool loi = false;

  @override
  Widget build(BuildContext context) {
    if (loi) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            "Có lỗi xảy ra",
            style: TextStyle(fontSize: 18),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    } else if (!ketnoi) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: GradientText(
              'MyMp3',
              style:
                  const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              gradientType: GradientType.linear,
              gradientDirection: GradientDirection.ttb,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade900,
              ],
            ),
          ),
        ),
      );
    } else {
      return const MaterialApp(title: "My Firebase App", home: HomePage());
    }
  }

  @override
  void initState() {
    super.initState();
    _khoiTaoFirebase();
  }

  _khoiTaoFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        ketnoi = true;
      });
    } catch (e) {
      loi = true;
    }
  }
}
