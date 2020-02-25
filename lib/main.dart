import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/favorite.dart';
import 'views/index.dart';

void main() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  WidgetsFlutterBinding.ensureInitialized();
  run();
}

void run() async {
  await Favorite.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
        child: MaterialApp(
      title: '开眼视频',
      theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Color(0xFFd46550),
          indicatorColor: Colors.white),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: Index(),
    ));
  }
}
