import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/feedback.dart';
import '../auth_actions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // O perfil abre em modo de leitura; o usuário precisa tocar em "Editar".
  bool _editing = false;

  late final _nameCtrl = TextEditingController(text: profileStore.name);
  late final _phoneCtrl = TextEditingController(text: profileStore.phone);
  late final _birthCtrl = TextEditingController(text: profileStore.birthDate);
  late final _ecNameCtrl = TextEditingController(text: profileStore.emergencyName);
  late final _ecPhoneCtrl = TextEditingController(text: profileStore.emergencyPhone);
  late final _ecRelationCtrl = TextEditingController(text: profileStore.emergencyRelation);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _birthCtrl.dispose();
    _ecNameCtrl.dispose();
    _ecPhoneCtrl.dispose();
    _ecRelationCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      AppFeedback.warning(context, 'Verifique os campos destacados');
      return;
    }
    profileStore.update(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      birthDate: _birthCtrl.text.trim(),
    );
    profileStore.updateEmergencyContact(
      name: _ecNameCtrl.text.trim(),
      phone: _ecPhoneCtrl.text.trim(),
      relation: _ecRelationCtrl.text.trim(),
    );
    FocusScope.of(context).unfocus();
    setState(() => _editing = false);
    AppFeedback.success(context, 'Perfil atualizado com sucesso');
  }

  void _startEditing() => setState(() => _editing = true);

  void _cancelEditing() {
    // Descarta alterações: restaura os campos com os valores salvos.
    _nameCtrl.text = profileStore.name;
    _phoneCtrl.text = profileStore.phone;
    _birthCtrl.text = profileStore.birthDate;
    _ecNameCtrl.text = profileStore.emergencyName;
    _ecPhoneCtrl.text = profileStore.emergencyPhone;
    _ecRelationCtrl.text = profileStore.emergencyRelation;
    _formKey.currentState?.reset();
    FocusScope.of(context).unfocus();
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _ProfileHeader(onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DADOS PESSOAIS', style: _sectionStyle),
                    const SizedBox(height: 12),
                    _label('Nome completo'),
                    const SizedBox(height: 8),
                    _field(_nameCtrl, hint: 'Ex: João Silva', icon: Icons.person_outline, validator: _required),
                    const SizedBox(height: 16),
                    _label('Telefone'),
                    const SizedBox(height: 8),
                    _field(_phoneCtrl, hint: '(71) 99999-9999', icon: Icons.phone_outlined,
                        keyboard: TextInputType.phone, validator: _phone, formatters: [PhoneInputFormatter()]),
                    const SizedBox(height: 16),
                    _label('Data de nascimento'),
                    const SizedBox(height: 8),
                    _field(_birthCtrl, hint: 'DD/MM/AAAA', icon: Icons.calendar_today_outlined,
                        keyboard: TextInputType.number, validator: _date, formatters: [DateInputFormatter()]),
                    const SizedBox(height: 28),
                    const Text('CONTATO DE EMERGÊNCIA', style: _sectionStyle),
                    const SizedBox(height: 12),
                    _label('Nome'),
                    const SizedBox(height: 8),
                    _field(_ecNameCtrl, hint: 'Ex: Maria Silva', icon: Icons.contact_emergency_outlined, validator: _required),
                    const SizedBox(height: 16),
                    _label('Parentesco'),
                    const SizedBox(height: 8),
                    _field(_ecRelationCtrl, hint: 'Ex: Cônjuge', icon: Icons.group_outlined, validator: _required),
                    const SizedBox(height: 16),
                    _label('Telefone'),
                    const SizedBox(height: 8),
                    _field(_ecPhoneCtrl, hint: '(71) 99999-9999', icon: Icons.phone_outlined,
                        keyboard: TextInputType.phone, validator: _phone, formatters: [PhoneInputFormatter()]),
                    const SizedBox(height: 28),
                    if (_editing) ...[
                      ElevatedButton(onPressed: _save, child: const Text('Salvar alterações')),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _cancelEditing,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.lightTextSecondary,
                          side: const BorderSide(color: AppColors.lightDivider),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: _startEditing,
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        label: const Text('Editar dados'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => confirmAndLogout(context),
                        icon: const Icon(Icons.logout, size: 20),
                        label: const Text('Sair da conta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.emergencyRed,
                          side: const BorderSide(color: AppColors.emergencyRed),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- validadores ---
  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null;

  String? _phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Telefone inválido';
    return null;
  }

  String? _date(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(v.trim())) return 'Use o formato DD/MM/AAAA';
    return null;
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500, fontSize: 14));

  Widget _field(
    TextEditingController controller, {
    required String hint,
    required IconData icon,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: formatters,
      // Em modo de leitura os campos não são editáveis (só após "Editar").
      readOnly: !_editing,
      style: const TextStyle(color: AppColors.lightText),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.lightTextSecondary, size: 20),
        filled: true,
        fillColor: _editing ? AppColors.lightInputFill : AppColors.lightBackground,
      ),
      validator: validator,
    );
  }

  static const _sectionStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.lightTextSecondary,
    letterSpacing: 1.2,
  );
}

class _ProfileHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _ProfileHeader({required this.onBack});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    ),
                  ),
                  const Text('Meu Perfil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ListenableBuilder(
                    listenable: profileStore,
                    builder: (context, _) => CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(profileStore.initials,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: profileStore,
                    builder: (context, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profileStore.name,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(profileStore.phone, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
