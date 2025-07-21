import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final TextStyle? style;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool readOnly;
  final String? initialValue;

  const PhoneNumberInputField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.validator,
    this.decoration,
    this.style,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.readOnly = false,
    this.initialValue,
  });

  @override
  State<PhoneNumberInputField> createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = _formatPhoneNumber(widget.initialValue!);
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final selection = _controller.selection;
    if (text == _previousText) return;

    // 记录光标前有多少个数字
    int numDigitsBeforeCursor = 0;
    for (int i = 0; i < selection.baseOffset && i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) {
        numDigitsBeforeCursor++;
      }
    }

    // 移除所有非数字字符
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    // 限制最大长度为11位
    String limitedDigits = digitsOnly.length > 11 ? digitsOnly.substring(0, 11) : digitsOnly;
    // 格式化手机号
    final formatted = _formatPhoneNumber(limitedDigits);

    // 计算新光标位置：在格式化后字符串中找到第numDigitsBeforeCursor个数字后的位置
    int newCursor = 0;
    int digitsCount = 0;
    for (; newCursor < formatted.length; newCursor++) {
      if (RegExp(r'\d').hasMatch(formatted[newCursor])) {
        digitsCount++;
      }
      if (digitsCount == numDigitsBeforeCursor) {
        newCursor++;
        break;
      }
    }
    if (newCursor > formatted.length) newCursor = formatted.length;

    if (formatted != text) {
      _previousText = formatted;
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: newCursor),
      );
    }
    else {
      _previousText = text;
    }
    if (widget.onChanged != null) {
      widget.onChanged!(limitedDigits);
    }
  }

  String _formatPhoneNumber(String digits) {
    if (digits.isEmpty) return '';
    if (digits.length <= 3) {
      return digits;
    }
    else if (digits.length <= 7) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    }
    else {
      return '${digits.substring(0, 3)} ${digits.substring(3, 7)} ${digits.substring(7)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      onTap: widget.onTap,
      validator: widget.validator,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType ?? TextInputType.phone,
      maxLength: widget.maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
        ...?widget.inputFormatters,
      ],
      decoration: widget.decoration ?? InputDecoration(
        hintText: widget.hintText ?? '请输入手机号',
        labelText: widget.labelText,
        border: const UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Theme.of(context).brightness == Brightness.dark ? Colors.white30 : Colors.grey[300]!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        counterText: '',
      ),
      style: widget.style ?? const TextStyle(fontSize: 20),
    );
  }
}

extension PhoneNumberInputFieldExtension on PhoneNumberInputField {
  String get cleanPhoneNumber {
    final controller = this.controller;
    if (controller == null) return '';
    return controller.text.replaceAll(RegExp(r'[^\d]'), '');
  }
} 