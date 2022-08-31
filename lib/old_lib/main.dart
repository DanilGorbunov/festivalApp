import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
  // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
       home: HomePage(),
    );
  }
}

