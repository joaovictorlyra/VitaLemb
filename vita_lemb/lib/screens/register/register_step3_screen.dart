import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/feedback.dart';
import '../main_shell.dart';

class RegisterStep3Screen extends StatefulWidget {
  const RegisterStep3Screen({super.key});

  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  int _relation = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (!_formKey.currentState!.validate()) {
      AppFeedback.warning(context, 'Verifique os campos destacados');
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.lightCard,
        icon: const Icon(Icons.check_circle, color: AppColors.successGreen, size: 48),
        title: const Text('Conta criada com sucesso!', textAlign: TextAlign.center),
        content: const Text(
          'Tudo pronto. Vamos começar a cuidar da sua saúde.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.lightTextSecondary),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Começar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
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
          _Step3Header(onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contato de emergência',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.lightText),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Quem ligar em caso de urgência?',
                      style: TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Este contato será automaticamente acionado ao pressionar o botão de ajuda.',
                              style: TextStyle(color: AppColors.lightText, fontSize: 13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _label('Nome do contato'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: AppColors.lightText),
                      decoration: const InputDecoration(
                        hintText: 'Ex: Maria Silva',
                        prefixIcon: Icon(Icons.person_outline, color: AppColors.lightTextSecondary, size: 20),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome do contato' : null,
                    ),
                    const SizedBox(height: 20),
                    _label('Parentesco'),
                    const SizedBox(height: 10),
                    _RelationChips(selected: _relation, onSelect: (v) => setState(() => _relation = v)),
                    const SizedBox(height: 20),
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
                        if (v == null || v.trim().isEmpty) return 'Informe o telefone';
                        if (v.replaceAll(RegExp(r'\D'), '').length < 10) return 'Telefone inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _finish,
                      child: const Text('Concluir cadastro'),
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

class _Step3Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Step3Header({required this.onBack});

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
              Expanded(
                child: Row(
                  children: List.generate(3, (i) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelationChips extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;

  const _RelationChips({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = ['Cônjuge', 'Filho(a)', 'Cuidador'];
    return Wrap(
      spacing: 10,
      children: options.asMap().entries.map((e) {
        final isSelected = e.key == selected;
        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : AppColors.lightCard,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : AppColors.lightDivider,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
              ],
            ),
            child: Text(
              e.value,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
