import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'dart:async';
import 'dart:convert';

class LocalStorage {
  static LocalStorage? _instance;
  static SharedPreferences? sharedPreferences;
  static final Lock _lock = Lock();

  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      await _lock.synchronized(() async {
        if (_instance == null) {
          // keep local instance till it is fully initialized.
          var instance = LocalStorage._();
          await instance._initialize();
          _instance = instance;
        }
      });
    }
    return _instance!;
  }

  Future _initialize() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  LocalStorage._();

  
  static Future<bool> setObject(String key, Object? value) {
    return sharedPreferences!.setString(key, value == null ? "" : json.encode(value));
  }

  static Map<String, dynamic>? getObject(String key) {
    String? _data = sharedPreferences!.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data) as Map<String, dynamic>;
  }

  static String getString(String key, {String defValue = ''}) {
    if (sharedPreferences == null) return defValue;
    return sharedPreferences!.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String? value) {
    if (sharedPreferences == null) return Future.value(false);
    if (value == null) {
      return sharedPreferences!.remove(key);
    }
    return sharedPreferences!.setString(key, value);
  }

  static bool getBool(String key, {bool defValue = false}) {
    if (sharedPreferences == null) return defValue;
    return sharedPreferences!.getBool(key) ?? defValue;
  }

  static Future<bool> setBool(String key, bool value) {
    if (sharedPreferences == null) return Future.value(false);
    return sharedPreferences!.setBool(key, value);
  }
  
  static int getInt(String key, {int defValue = 0}) {
    if (sharedPreferences == null) return defValue;
    return sharedPreferences!.getInt(key) ?? defValue;
  }
  
  static Future<bool> setInt(String key, int value) {
    if (sharedPreferences == null) return Future.value(false);
    return sharedPreferences!.setInt(key, value);
  }
  
  static double getDouble(String key, {double defValue = 0.0}) {
    if (sharedPreferences == null) return defValue;
    return sharedPreferences!.getDouble(key) ?? defValue;
  }
  
  static Future<bool> setDouble(String key, double value) {
    if (sharedPreferences == null) return Future.value(false);
    return sharedPreferences!.setDouble(key, value);
  }
  
  static List<String> getStringList(String key, {List<String> defValue = const []}) {
    if (sharedPreferences == null) return defValue;
    return sharedPreferences!.getStringList(key) ?? defValue;
  }
  
  static Future<bool> setStringList(String key, List<String> value) {
    if (sharedPreferences == null) return Future.value(false);
    return sharedPreferences!.setStringList(key, value);
  }
  
  static dynamic getDynamic(String key, {Object? defValue}) {
    if (sharedPreferences == null) return defValue;
    return sharedPreferences!.get(key) ?? defValue;
  }
  
  static bool haveKey(String key) {
    if (sharedPreferences == null) return false;
    return sharedPreferences!.getKeys().contains(key);
  }
  
  static Set<String> getKeys() {
    if (sharedPreferences == null) return <String>{};
    return sharedPreferences!.getKeys();
  }
  
  static Future<bool> remove(String key) {
    if (sharedPreferences == null) return Future.value(false);
    return sharedPreferences!.remove(key);
  }
  
  static Future<bool> clear() {
    if (sharedPreferences == null) return Future.value(false);
    return sharedPreferences!.clear();
  }
  
  static bool isInitialized() {
    return sharedPreferences != null;
  }
}