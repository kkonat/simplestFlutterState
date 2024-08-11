import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simplest_statemgmt/state.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  AppState appState = AppState(); // get singleton reference
  late StreamController<Future<String>> _timeStreamController;

  @override
  void initState() {
    super.initState();
    _timeStreamController = StreamController<Future<String>>();
    _startTimer();
  }

  @override
  void dispose() {
    _timeStreamController.close();
    appState.saveState();
    super.dispose();
  }

  void _startTimer() {
    Timer.periodic(const Duration(milliseconds: 900), (timer) async {
      try {
        final time = appState.getTime();
        _timeStreamController.add(time);
      } catch (e) {
        _timeStreamController.addError("NTP error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Future<String>>(
        stream: _timeStreamController.stream,
        builder: (context, snapshot) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFromNetwork(snapshot: snapshot),
                Text("${appState.count}", style: const TextStyle(fontSize: 30)),
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    button(() => appState.countAdd(1), Icons.add),
                    button(() => appState.countSet(0), Icons.clear),
                    button(() => appState.countAdd(-1), Icons.remove),
                  ],
                ),
              ],
            ),
          );
        });
  }

  FloatingActionButton button(Function func, IconData icon) {
    return FloatingActionButton(
      onPressed: () => setState(() => func()),
      child: Icon(icon),
    );
  }
}

class TextFromNetwork extends StatelessWidget {
  final AsyncSnapshot<Future<String>> snapshot;

  const TextFromNetwork({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      return FutureBuilder<String>(
          future: snapshot.data,
          builder: (context, futureSnapshot) {
            if (futureSnapshot.hasError) {
              return Text('Error: ${futureSnapshot.error}');
            } else if (futureSnapshot.hasData) {
              return Text('Current Time: ${futureSnapshot.data}');
            } else {
              return const Text('No data');
            }
          });
    } else {
      return const Text('No data');
    }
  }
}
