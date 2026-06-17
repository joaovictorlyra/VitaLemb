import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../state/app_state.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/feedback.dart';
import '../auth_actions.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _vibration = true;
  bool _loudSound = true;
  bool _flashAlert = true;
  bool _biometric = false;
  bool _shareDoctor = true;

  Future<void> _openCaregiverForm() async {
    final result = await showModalBottomSheet<({String name, String relation, String phone})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CaregiverFormSheet(
        initialName: caregiverStore.name,
        initialRelation: caregiverStore.relation,
        initialPhone: caregiverStore.phone,
      ),
    );
    if (result != null && mounted) {
      final isNew = !caregiverStore.hasCaregiver;
      caregiverStore.save(name: result.name, relation: result.relation, phone: result.phone);
      AppFeedback.success(context, isNew ? 'Cuidador adicionado' : 'Cuidador atualizado');
    }
  }

  void _removeCaregiver() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.lightCard,
        title: const Text('Remover cuidador'),
        content: const Text('Deseja desvincular este cuidador?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              caregiverStore.remove();
              AppFeedback.info(context, 'Cuidador removido');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed, minimumSize: const Size(0, 44)),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: ListenableBuilder(
        listenable: Listenable.merge([settingsStore, caregiverStore, profileStore]),
        builder: (context, _) {
          return Column(
            children: [
              const _AccessibilityHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const _SectionHeader(title: 'CONTATO DE EMERGÊNCIA'),
                    const _EmergencyContactTile(),
                    const _SectionHeader(title: 'CUIDADOR'),
                    _CaregiverSection(
                      onAddOrEdit: _openCaregiverForm,
                      onRemove: _removeCaregiver,
                    ),
                    const _SectionHeader(title: 'TEXTO E LEITURA'),
                    _ToggleTile(
                      label: 'Tamanho da Fonte',
                      subtitle: 'Aumenta o texto de todo o app',
                      value: settingsStore.largeFont,
                      onChanged: (v) {
                        settingsStore.setLargeFont(v);
                        AppFeedback.info(context, v ? 'Fonte ampliada' : 'Fonte no tamanho padrão');
                      },
                    ),
                    _ToggleTile(
                      label: 'Alto Contraste',
                      subtitle: 'Em breve',
                      value: settingsStore.highContrast,
                      onChanged: (v) {
                        setState(() => settingsStore.highContrast = v);
                        AppFeedback.info(context, 'Alto contraste chega na próxima atualização');
                      },
                    ),
                    const _SectionHeader(title: 'ALERTAS'),
                    _ToggleTile(label: 'Vibração', value: _vibration, onChanged: (v) => setState(() => _vibration = v)),
                    _ToggleTile(label: 'Som Alto', value: _loudSound, onChanged: (v) => setState(() => _loudSound = v)),
                    _ToggleTile(label: 'Alerta Visual (Flash)', value: _flashAlert, onChanged: (v) => setState(() => _flashAlert = v)),
                    const _SectionHeader(title: 'SEGURANÇA'),
                    _ToggleTile(label: 'Acesso com Digital', value: _biometric, onChanged: (v) => setState(() => _biometric = v)),
                    _ToggleTile(label: 'Compartilhar com Médico', value: _shareDoctor, onChanged: (v) => setState(() => _shareDoctor = v)),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AccessibilityHeader extends StatelessWidget {
  const _AccessibilityHeader();

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
      child: const SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              Text('⚙️', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('Acessibilidade', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _EmergencyContactTile extends StatelessWidget {
  const _EmergencyContactTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
            child: Text(
              _initials(profileStore.emergencyName),
              style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profileStore.emergencyName, style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600)),
                Text(profileStore.emergencyRelation, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.successGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.phone, color: AppColors.successGreen, size: 20),
              tooltip: 'Ligar',
              onPressed: () => AppFeedback.success(context, 'Ligando para ${profileStore.emergencyName}...'),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// Seção de cuidador: estado vazio com botão de adicionar, ou card do cuidador
/// com editar/remover e o controle de compartilhamento de dados.
class _CaregiverSection extends StatelessWidget {
  final VoidCallback onAddOrEdit;
  final VoidCallback onRemove;

  const _CaregiverSection({required this.onAddOrEdit, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (!caregiverStore.hasCaregiver) {
      return InkWell(
        onTap: onAddOrEdit,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.4)),
          ),
          child: const Row(
            children: [
              Icon(Icons.person_add_alt_1, color: AppColors.primaryBlue),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adicionar cuidador', style: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600, fontSize: 15)),
                    Text('Vincule alguém para acompanhar sua saúde', style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.lightTextSecondary),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                child: const Icon(Icons.health_and_safety, color: AppColors.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(caregiverStore.name!, style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600)),
                    Text('${caregiverStore.relation} · ${caregiverStore.phone}',
                        style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.primaryBlue, size: 20),
                tooltip: 'Editar',
                onPressed: onAddOrEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.emergencyRed, size: 20),
                tooltip: 'Remover',
                onPressed: onRemove,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _ToggleTile(
          label: 'Compartilhar dados com o cuidador',
          value: caregiverStore.sharingEnabled,
          onChanged: (v) {
            caregiverStore.setSharing(v);
            AppFeedback.info(context, v ? 'Compartilhamento ativado' : 'Compartilhamento desativado');
          },
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({required this.label, this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.lightText, fontSize: 15, fontWeight: FontWeight.w500)),
                if (subtitle != null)
                  Text(subtitle!, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.lightTextSecondary,
            inactiveTrackColor: AppColors.lightDivider,
          ),
        ],
      ),
    );
  }
}

/// Formulário (bottom sheet) para adicionar/editar o cuidador.
class _CaregiverFormSheet extends StatefulWidget {
  final String? initialName;
  final String? initialRelation;
  final String? initialPhone;

  const _CaregiverFormSheet({this.initialName, this.initialRelation, this.initialPhone});

  @override
  State<_CaregiverFormSheet> createState() => _CaregiverFormSheetState();
}

class _CaregiverFormSheetState extends State<_CaregiverFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.initialName ?? '');
  late final _relationCtrl = TextEditingController(text: widget.initialRelation ?? '');
  late final _phoneCtrl = TextEditingController(text: widget.initialPhone ?? '');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _relationCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      AppFeedback.warning(context, 'Verifique os campos destacados');
      return;
    }
    Navigator.pop(context, (
      name: _nameCtrl.text.trim(),
      relation: _relationCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = (widget.initialName ?? '').isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: AppColors.lightDivider, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text(isEditing ? 'Editar cuidador' : 'Adicionar cuidador',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.lightText)),
                const SizedBox(height: 20),
                _label('Nome do cuidador'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppColors.lightText),
                  decoration: const InputDecoration(hintText: 'Ex: Ana Souza', prefixIcon: Icon(Icons.person_outline, size: 20)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome do cuidador' : null,
                ),
                const SizedBox(height: 16),
                _label('Parentesco / vínculo'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _relationCtrl,
                  style: const TextStyle(color: AppColors.lightText),
                  decoration: const InputDecoration(hintText: 'Ex: Filha, Enfermeiro', prefixIcon: Icon(Icons.group_outlined, size: 20)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o vínculo' : null,
                ),
                const SizedBox(height: 16),
                _label('Telefone'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneInputFormatter()],
                  style: const TextStyle(color: AppColors.lightText),
                  decoration: const InputDecoration(hintText: '(71) 99999-9999', prefixIcon: Icon(Icons.phone_outlined, size: 20)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o telefone';
                    if (v.replaceAll(RegExp(r'\D'), '').length < 10) return 'Telefone inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.lightTextSecondary,
                          side: const BorderSide(color: AppColors.lightDivider),
                          minimumSize: const Size(0, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Cancelar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton(onPressed: _submit, child: const Text('Salvar'))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500, fontSize: 14));
}
