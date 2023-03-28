extension StringExtension on String {
  String removeSlash() {
    String str = replaceAll('/', '');
    return str;
  }
}
