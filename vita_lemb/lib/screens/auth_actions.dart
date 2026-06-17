import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'splash_screen.dart';

/// Pede confirmação e, se aceito, encerra a sessão voltando à tela inicial.
/// Usado tanto no Perfil quanto em Configurações para garantir um logout
/// sempre acessível (apontado como ausente na avaliação).
Future<void> confirmAndLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.lightCard,
      title: const Text('Sair da conta', style: TextStyle(color: AppColors.lightText)),
      content: const Text('Deseja realmente sair?', style: TextStyle(color: AppColors.lightTextSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed, minimumSize: const Size(0, 44)),
          child: const Text('Sair'),
        ),
      ],
    ),
  );

  if (shouldLogout == true && context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (_) => false,
    );
  }
}
