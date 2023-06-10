import 'package:chat_app/sheared/constance/constance.dart';
import 'package:chat_app/sheared/local/cache_helper.dart';
import 'package:chat_app/view/screen/android_screen.dart';
import 'package:chat_app/view/screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Constance.uId = CacheHelper.getData(key: "uId");
  late Widget startWidget;
  if (Constance.uId == null) {
    startWidget = const Login();
  } else {
    startWidget = const AndroidApp();
  }
  runApp(
    MyApp(
      startWidget: startWidget,
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: startWidget,
    );
  }
}
