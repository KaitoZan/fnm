import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName => '.env';

  static String get apiUrl => dotenv.env['API_URL']!;
  static String get appId => dotenv.env['APP_ID']!;
  static String get accessKey => dotenv.env['ACCESS_KEY']!;
  static String get secretKey => dotenv.env['SECRET_KEY']!;
}
