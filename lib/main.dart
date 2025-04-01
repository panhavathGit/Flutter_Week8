// REPOSITORY
// import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'Data/repository/async_value.dart';
import './Data/repository/firebase_repository.dart';
import './provider/song_provider.dart';
import './Data/repository/song_repository.dart';
import './screen/song_app_screen.dart';
void main() async {
  // 1 - Create repository
  final SongRepository songRepository = FirebaseSongRepository();
  // 2-  Run app
  runApp(
    ChangeNotifierProvider(
      create: (context) => SongProvider(songRepository),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: const App()),
    ),
  );
}
