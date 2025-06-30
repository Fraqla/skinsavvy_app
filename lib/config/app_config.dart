import 'package:flutter/foundation.dart'; // for kIsWeb
import 'dart:io'; // for Platform

class AppConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      return 'http://10.211.106.226:8000'; // use your Wi-Fi IPv4 here
    } else {
      return 'http://localhost:8000';
    }
  }
}
