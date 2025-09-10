import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/screens/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edvoyage',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 16)),
      ),
      home: NotesScreen(),
    );
  }
}
