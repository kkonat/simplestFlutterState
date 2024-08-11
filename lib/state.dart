import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  int count = 0;
  static String valuePrefsKey = 'counter';
  static int valuedefault = 0;

  String time = "...";

  static final AppState _singleton = AppState._internal(); // Declare singleton object

  AppState._internal(); // Declare private constructor
  factory AppState() => _singleton; // Declare factory constructor

  countAdd(int delta) => count += delta;
  countSet(int newValue) => count = newValue;

  saveState() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(valuePrefsKey, count);
  }

  loadState() async {
    var prefs = await SharedPreferences.getInstance();
    count = prefs.getInt(valuePrefsKey) ?? valuedefault;
  }

  Future<String> getTime() async {
    var now = await NTP.now();
    return now.toString().split('.')[0];
  }
}
