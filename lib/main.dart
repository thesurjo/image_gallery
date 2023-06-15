import 'package:flutter/material.dart';

import 'export/screen.export.dart';
import 'export/util.export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primarycolor),
        useMaterial3: true,
      
      ),
      home: const Splash(),
    );
  }
}
