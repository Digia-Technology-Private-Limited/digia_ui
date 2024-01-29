import 'dart:math';

// Read about Base 32 here:
// https://www.connect2id.com/blog/how-to-generate-human-friendly-identifiers
abstract class RandomIdGenerator {
  static final _base64chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_'
          .split('');

  static final _random = Random();

  static String getBase64(int length) {
    final sb = StringBuffer();
    for (int i = 0; i < length; i++) {
      sb.write(_base64chars[_random.nextInt(64)]);
    }
    return sb.toString();
  }

  static String getBase62(int length) {
    final sb = StringBuffer();
    for (int i = 0; i < length; i++) {
      sb.write(_base64chars[_random.nextInt(62)]);
    }
    return sb.toString();
  }

  static String getBase36(int length) {
    final sb = StringBuffer();
    for (int i = 0; i < length; i++) {
      sb.write(_base64chars[_random.nextInt(36)]);
    }
    return sb.toString();
  }
}
