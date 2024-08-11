import 'package:simplest_statemgmt/state.dart';
import 'package:simplest_statemgmt/page.dart';
import 'dart:async';

import 'package:flutter/material.dart';

final appState = AppState();

const appName = "Simplest statemgmt";

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  AppState appState = AppState();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    appState.loadState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    appState.saveState();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      appState.getTime();
      setState(() {});
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      appState.saveState(); // Save state when the app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AppPage(
          appState: appState,
          key: null,
        ),
      ),
    );
  }
}
