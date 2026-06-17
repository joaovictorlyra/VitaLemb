import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Seletor de horário em roda de rolagem (scroll), preferido em vez do
/// relógio (dial). O usuário gira as colunas de hora e minuto para escolher.
Future<TimeOfDay?> showTimeWheel(BuildContext context, {TimeOfDay? initial}) {
  final now = DateTime.now();
  final start = initial ?? const TimeOfDay(hour: 8, minute: 0);
  var temp = DateTime(now.year, now.month, now.day, start.hour, start.minute);

  return showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: AppColors.lightCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('Cancelar', style: TextStyle(color: AppColors.lightTextSecondary)),
                  ),
                  const Text('Selecionar horário',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.lightText)),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      sheetContext,
                      TimeOfDay(hour: temp.hour, minute: temp.minute),
                    ),
                    child: const Text('Confirmar', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.lightDivider),
            SizedBox(
              height: 200,
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(fontSize: 22, color: AppColors.lightText),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: temp,
                  onDateTimeChanged: (value) => temp = value,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
