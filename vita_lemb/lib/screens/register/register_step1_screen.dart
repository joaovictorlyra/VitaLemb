import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/feedback.dart';
import '../splash_screen.dart';
import 'register_step2_screen.dart';

class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _birthCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      AppFeedback.warning(context, 'Verifique os campos destacados');
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterStep2Screen()));
  }

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
              child: Form(
                key: _formKey,
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
                    _label('Nome completo'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: AppColors.lightText),
                      decoration: const InputDecoration(
                        hintText: 'Ex: João Silva',
                        prefixIcon: Icon(Icons.person_outline, color: AppColors.lightTextSecondary, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Informe seu nome completo';
                        if (v.trim().split(RegExp(r'\s+')).length < 2) return 'Informe nome e sobrenome';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _label('Data de nascimento'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _birthCtrl,
                      keyboardType: TextInputType.datetime,
                      style: const TextStyle(color: AppColors.lightText),
                      decoration: const InputDecoration(
                        hintText: 'DD/MM/AAAA',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.lightTextSecondary, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Informe sua data de nascimento';
                        if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(v.trim())) return 'Use o formato DD/MM/AAAA';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _label('Telefone'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.lightText),
                      decoration: const InputDecoration(
                        hintText: '(71) 9999-9999',
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
                        hintText: 'Mínimo 8 caracteres',
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
                        if (v == null || v.isEmpty) return 'Crie uma senha';
                        if (v.length < 8) return 'A senha deve ter ao menos 8 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.security, size: 14, color: AppColors.lightTextSecondary),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Seus dados são protegidos e nunca compartilhados sem sua autorização.',
                            style: TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _continue,
                      child: const Text('Continuar →'),
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
