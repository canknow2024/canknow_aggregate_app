import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class ResourceUtil {
  Future<String> loadJson(String name) async {
    return await rootBundle.loadString('assets/$name.json');
  }
  
  static String getImagePath(String path) {
    return 'assets/images/$path';
  }
}