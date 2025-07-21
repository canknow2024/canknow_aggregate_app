import 'package:flutter/material.dart';

class TextUtil {
  static bool isEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.isNotEmpty && "" != text.trim();
  }

  /// 每隔 x位 加 pattern
  static String formatDigitPattern(String text, {int digit = 4, String pattern = ' '}) {
    text = text.replaceAllMapped(RegExp("(.{$digit})"), (Match match) {
      return "${match.group(0)}$pattern";
    });
    if (text.endsWith(pattern)) {
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  /// 每隔 x位 加 pattern, 从末尾开始
  static String formatDigitPatternEnd(String text, {int digit = 4, String pattern = ' '}) {
    String temp = reverse(text);
    temp = formatDigitPattern(temp, digit: 3, pattern: ',');
    temp = reverse(temp);
    return temp;
  }

  /// 每隔4位加空格
  static String formatSpace4(String text) {
    return formatDigitPattern(text);
  }

  /// 每隔3三位加逗号
  /// num 数字或数字字符串。int型。
  static String formatComma3(Object num) {
    return formatDigitPatternEnd(num.toString(), digit: 3, pattern: ',');
  }

  /// hideNumber
  static String hideNumber(String phoneNo, {int start = 3, int end = 7, String replacement = '****'}) {
    return phoneNo.replaceRange(start, end, replacement);
  }

  /// replace
  static String replace(String text, Pattern from, String replace) {
    return text.replaceAll(from, replace);
  }

  /// split
  static List<String> split(String text, Pattern pattern) {
    List<String> list = text.split(pattern);
    return list;
  }

  /// reverse
  static String reverse(String text) {
    if (isEmpty(text)) return '';
    StringBuffer sb = StringBuffer();
    for (int i = text.length - 1; i >= 0; i--) {
      sb.writeCharCode(text.codeUnitAt(i));
    }
    return sb.toString();
  }

  static String encryptedMobile(String mobile) {
    return mobile.substring(0,3) + "****" + mobile.substring(7, mobile.length);
  }

  static double calculateTextHeight(String value, { double? fontSize, FontWeight? fontWeight, double maxWidth = double.infinity, int? maxLines }) {
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter.height;
  }

  static double calculateTextWidth(String value, { double? fontSize, FontWeight? fontWeight, double maxWidth = double.infinity, int? maxLines }) {
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter.width;
  }
}
