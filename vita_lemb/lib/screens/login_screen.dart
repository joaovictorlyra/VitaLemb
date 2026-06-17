import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/input_formatters.dart';
import '../widgets/feedback.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      AppFeedback.warning(context, 'Verifique os campos destacados');
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _LoginHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Telefone'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [PhoneInputFormatter()],
                      style: const TextStyle(color: AppColors.lightText),
                      decoration: const InputDecoration(
                        hintText: '(71) 99999-9999',
                        prefixIcon: Icon(Icons.phone_outlined, color: AppColors.lightTextSecondary, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Informe seu telefone';
                        if (v.replaceAll(RegExp(r'\D'), '').length < 10) return 'Telefone inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _label('Senha'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: AppColors.lightText),
                      decoration: InputDecoration(
                        hintText: 'Sua senha',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.lightTextSecondary, size: 20),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: AppColors.lightTextSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Informe sua senha';
                        if (v.length < 8) return 'A senha deve ter ao menos 8 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => AppFeedback.info(context, 'Enviamos as instruções para o seu telefone'),
                        child: const Text(
                          'Esqueceu a senha?',
                          style: TextStyle(color: AppColors.primaryBlue, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Entrar'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500, fontSize: 14),
      );
}

class _LoginHeader extends StatelessWidget {
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bem-vindo\nde volta',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
              ),
              const SizedBox(height: 6),
              const Text(
                'Faça login para continuar',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
