import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService instance = SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return instance;
  }

  SharedPreferencesService._internal();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setString(String key, String? value) async {
    SharedPreferences prefs = await _prefs;
    if (value != null && value.isNotEmpty) {
      prefs.setString(key, value);
    }
  }

  Future<String?> getString(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key) ? prefs.getString(key) : "";
  }

  Future<void> setBool(String key, bool? value) async {
    SharedPreferences prefs = await _prefs;
    if (value != null) {
      prefs.setBool(key, value);
    }
  }

  Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key) ? prefs.getBool(key) : false;
  }

  Future<bool> checkKey(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

  Future<void> clearLocalData() async {
    SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
