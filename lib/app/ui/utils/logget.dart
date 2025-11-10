import 'dart:developer' as dev;

import 'package:logging/logging.dart';

abstract class Log {
  static final Logger _logger = Logger('MyApp');

  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      dev.log(
        record.message,
        level: record.level.value,
        time: record.time,
        name: record.loggerName,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  static void debug(String message) {
    _logger.fine(message);
  }

  static void info(String message) {
    _logger.info(message);
  }

  static void warning(String message) {
    _logger.warning(message);
  }

  static void error(String message, [Object? error]) {
    _logger.severe(
      message,
      error,
      StackTrace.current,
    );
  }
}
