import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../splash_screen.dart';
import 'register_step2_screen.dart';

class RegisterStep1Screen extends StatelessWidget {
  const RegisterStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _RegisterHeader(
            current: 1,
            onBack: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SplashScreen()),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Criar sua conta',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.lightText),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Preencha seus dados pessoais',
                    style: TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
                  ),
                  const SizedBox(height: 32),
                  _buildLabel('Nome completo'),
                  const SizedBox(height: 8),
                  _buildInput(hint: 'Ex: João Silva', icon: Icons.person_outline),
                  const SizedBox(height: 20),
                  _buildLabel('Data de nascimento'),
                  const SizedBox(height: 8),
                  _buildInput(hint: 'DD/MM/AAAA', icon: Icons.calendar_today_outlined),
                  const SizedBox(height: 20),
                  _buildLabel('Telefone'),
                  const SizedBox(height: 8),
                  _buildInput(hint: '(71) 9999-9999', icon: Icons.phone_outlined),
                  const SizedBox(height: 20),
                  _buildLabel('Senha'),
                  const SizedBox(height: 8),
                  _buildInput(hint: 'Mínimo 8 caracteres', icon: Icons.lock_outline, obscure: true),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.security, size: 14, color: AppColors.lightTextSecondary),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Seus dados são protegidos e nunca compartilhados sem sua autorização.',
                          style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterStep2Screen()),
                    ),
                    child: const Text('Continuar →'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500, fontSize: 14),
      );

  Widget _buildInput({required String hint, required IconData icon, bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: AppColors.lightText),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.lightTextSecondary, size: 20),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  final int current;
  final VoidCallback onBack;

  const _RegisterHeader({required this.current, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyBlue, AppColors.primaryBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                ),
              ),
              Expanded(child: _StepIndicator(current: current)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  const _StepIndicator({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final active = i + 1 == current;
        final done = i + 1 < current;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                color: (active || done) ? Colors.white : Colors.white.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
