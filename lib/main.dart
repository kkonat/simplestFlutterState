import 'package:flutter/material.dart';
import 'package:simplest_statemgmt/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.loadState(); // Load state before running the app
  runApp(const App());
}
