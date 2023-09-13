import 'dart:convert';

import 'package:delivery_app/auth/constants/data.dart';

class DataUtils {
  static String pathToUrl(String value) => 'http://$ip$value';
  static List<String> listPathsToUrls(List paths) =>
      paths.map((e) => pathToUrl(e)).toList();
  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(plain);
  }

  static DateTime stringToDateTime(String value) => DateTime.parse(value);
}
