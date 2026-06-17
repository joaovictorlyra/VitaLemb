import 'package:flutter/services.dart';

/// Formata o telefone brasileiro enquanto o usuário digita.
/// Aceita no máximo 11 dígitos: `(XX) XXXXX-XXXX` (celular) ou
/// `(XX) XXXX-XXXX` (fixo).
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) digits = digits.substring(0, 11);

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      // O traço fica antes dos 4 últimos dígitos (varia entre fixo e celular).
      if (digits.length <= 10) {
        if (i == 6) buffer.write('-');
      } else {
        if (i == 7) buffer.write('-');
      }
      buffer.write(digits[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Formata uma data enquanto o usuário digita, no formato `DD/MM/AAAA`.
/// Aceita no máximo 8 dígitos (impede ultrapassar o tamanho da data).
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digits[i]);
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
