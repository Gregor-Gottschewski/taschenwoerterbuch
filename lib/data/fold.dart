import 'package:unorm_dart/unorm_dart.dart' as unorm;

final _combining = RegExp(r'[̀-ͯ]');

/// Normalizing the input string to match standard latin characters.
String fold(String text) {
  final s = text
      .toLowerCase()
      .replaceAll('ß', 'ss')
      .replaceAll('œ', 'oe')
      .replaceAll('æ', 'ae');
  return unorm.nfkd(s).replaceAll(_combining, '');
}
