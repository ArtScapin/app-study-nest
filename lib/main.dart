import 'dart:io';
import 'package:app_study_nest/views/android/app.dart';
import 'package:flutter/material.dart';

void main() {
  if (Platform.isAndroid) {
    runApp(const App());
  } else if (Platform.isIOS) {
    debugPrint('IOS');
  }
}