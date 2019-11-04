import 'dart:io';

class Log {
  static i(String msg) {
    info(msg);
  }

  static w(String msg) {
    warn(msg);
  }

  static e(String msg) {
    error(msg);
  }

  static info(String msg) {
    stdout.write('[INFO] ${msg}\n');
  }

  static warn(String msg) {
    stdout.write('[WARN] ${msg}\n');
  }

  static error(String msg) {
    stdout.write('[ERROR] ${msg}\n');
  }
}
