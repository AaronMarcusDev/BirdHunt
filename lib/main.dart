import 'package:flutter/material.dart';
import 'package:birdhunt/pages/vogel_overzicht.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(title: 'BirdHunt', home: BirdList()));
}