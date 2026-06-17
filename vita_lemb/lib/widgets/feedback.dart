import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Mensagens de retorno padronizadas (sucesso, erro, aviso, informação).
///
/// Centraliza o feedback visual do app: toda ação relevante deve chamar um
/// destes métodos para que o usuário saiba o resultado do que fez.
class AppFeedback {
  AppFeedback._();

  static void success(BuildContext context, String message) =>
      _show(context, message, AppColors.successGreen, Icons.check_circle);

  static void error(BuildContext context, String message) =>
      _show(context, message, AppColors.emergencyRed, Icons.error);

  static void warning(BuildContext context, String message) =>
      _show(context, message, AppColors.warningOrange, Icons.warning_amber_rounded);

  static void info(BuildContext context, String message) =>
      _show(context, message, AppColors.primaryBlue, Icons.info);

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon, {
    SnackBarAction? action,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        action: action,
      ),
    );
  }

  /// Sucesso com um botão de ação (ex.: "Desfazer" ao remover um remédio).
  static void successWithAction(
    BuildContext context,
    String message, {
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    _show(
      context,
      message,
      AppColors.successGreen,
      Icons.check_circle,
      action: SnackBarAction(
        label: actionLabel,
        textColor: Colors.white,
        onPressed: onAction,
      ),
    );
  }
}
