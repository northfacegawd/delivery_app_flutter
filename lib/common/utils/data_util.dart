import 'package:delivery_app/auth/constants/data.dart';

class DataUtils {
  static String pathToUrl(String value) => 'http://$ip$value';
  static List<String> listPathsToUrls(List paths) =>
      paths.map((e) => pathToUrl(e)).toList();
}
