
extension StringExtension on String {
  String get extension {
    return split("/").last;
  }
}