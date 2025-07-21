String getNullableText (String? text, { String emptyText = "-" }) {
  if (text == null || text == '') {
    return emptyText;
  }
  return text;
}