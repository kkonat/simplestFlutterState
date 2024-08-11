import 'package:flutter/material.dart';
import 'package:simplest_statemgmt/state.dart';

class AppPage extends StatefulWidget {
  final AppState appState;

  const AppPage({super.key, required this.appState});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Current time : ${widget.appState.time}", style: const TextStyle(fontSize: 20)),
          Text("${widget.appState.count}", style: const TextStyle(fontSize: 30)),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: [
              button(() => widget.appState.countAdd(1), Icons.add),
              button(() => widget.appState.countSet(0), Icons.clear),
              button(() => widget.appState.countAdd(-1), Icons.remove),
            ],
          ),
        ],
      ),
    );
  }

  FloatingActionButton button(Function func, IconData icon) {
    return FloatingActionButton(
      onPressed: () => setState(() => func()),
      child: Icon(icon),
    );
  }
}
