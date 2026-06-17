import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/mock_data.dart';
import '../../state/app_state.dart';
import '../../widgets/feedback.dart';
import '../../widgets/time_wheel_picker.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  Future<void> _addMedication(BuildContext context) async {
    final med = await showModalBottomSheet<Medication>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _MedicationFormSheet(),
    );
    if (med != null && context.mounted) {
      medicationStore.add(med);
      AppFeedback.success(context, 'Remédio "${med.name}" adicionado');
    }
  }

  void _confirmRemove(BuildContext context, Medication med) {
    final index = medicationStore.indexOf(med);
    medicationStore.remove(med);
    AppFeedback.successWithAction(
      context,
      'Remédio "${med.name}" removido',
      actionLabel: 'Desfazer',
      onAction: () => medicationStore.insertAt(index, med),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMedication(context),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: ListenableBuilder(
        listenable: medicationStore,
        builder: (context, _) {
          final groups = medicationStore.grouped;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MedicationsHeader(takenCount: medicationStore.takenCount, total: medicationStore.total),
              Expanded(
                child: groups.isEmpty
                    ? const _EmptyState()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                        children: groups.entries.map((group) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  group.key,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.lightTextSecondary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              ...group.value.map((med) => _MedTile(
                                    med: med,
                                    onToggle: () {
                                      medicationStore.toggle(med);
                                      AppFeedback.info(
                                        context,
                                        med.taken
                                            ? '"${med.name}" marcado como tomado'
                                            : '"${med.name}" marcado como pendente',
                                      );
                                    },
                                    onRemove: () => _confirmRemove(context, med),
                                  )),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('💊', style: TextStyle(fontSize: 44)),
            SizedBox(height: 12),
            Text(
              'Nenhum remédio cadastrado',
              style: TextStyle(color: AppColors.lightText, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              'Toque em "Adicionar" para criar\nseu primeiro lembrete.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationsHeader extends StatelessWidget {
  final int takenCount;
  final int total;

  const _MedicationsHeader({required this.takenCount, required this.total});

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
              const Row(children: [
                Text('💊', style: TextStyle(fontSize: 22)),
                SizedBox(width: 8),
                Text('Remédios Hoje', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ]),
              const SizedBox(height: 4),
              const Text('Domingo, 3 de maio', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
              _ProgressBar(taken: takenCount, total: total),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int taken;
  final int total;
  const _ProgressBar({required this.taken, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? taken / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$taken de $total tomados',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _MedTile extends StatelessWidget {
  final Medication med;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  const _MedTile({required this.med, required this.onToggle, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(med),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.emergencyRed,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline, color: Colors.white),
            SizedBox(width: 6),
            Text('Remover', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: AppColors.lightCard,
                title: const Text('Remover remédio'),
                content: Text('Deseja remover "${med.name}" da sua lista?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emergencyRed,
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text('Remover'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onRemove(),
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(14),
            border: Border(
              left: BorderSide(
                color: med.taken ? AppColors.successGreen : AppColors.primaryBlue,
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('💊', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med.name, style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600, fontSize: 15)),
                    Text(med.dosage, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
                    Text(med.time, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: med.taken ? AppColors.successGreen : Colors.transparent,
                  border: Border.all(
                    color: med.taken ? AppColors.successGreen : AppColors.lightTextSecondary,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: med.taken ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formulário (bottom sheet) para adicionar um remédio / lembrete.
class _MedicationFormSheet extends StatefulWidget {
  const _MedicationFormSheet();

  @override
  State<_MedicationFormSheet> createState() => _MedicationFormSheetState();
}

class _MedicationFormSheetState extends State<_MedicationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  TimeOfDay? _time;
  String _period = medicationPeriods.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    super.dispose();
  }

  String get _timeLabel {
    final t = _time;
    if (t == null) return '';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime() async {
    final picked = await showTimeWheel(context, initial: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _submit() {
    final validForm = _formKey.currentState!.validate();
    if (_time == null || !validForm) {
      AppFeedback.warning(context, 'Verifique os campos destacados');
      setState(() {}); // mostra o erro do horário
      return;
    }
    Navigator.pop(
      context,
      Medication(
        name: _nameCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim(),
        time: _timeLabel,
        taken: false,
        period: _period,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
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
                const Text('Novo remédio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.lightText)),
                const SizedBox(height: 4),
                const Text('O horário define o lembrete diário.', style: TextStyle(fontSize: 13, color: AppColors.lightTextSecondary)),
                const SizedBox(height: 20),
                _label('Nome do remédio'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: AppColors.lightText),
                  decoration: const InputDecoration(hintText: 'Ex: Losartana', prefixIcon: Icon(Icons.medication_outlined, size: 20)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome do remédio' : null,
                ),
                const SizedBox(height: 16),
                _label('Dosagem'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dosageCtrl,
                  style: const TextStyle(color: AppColors.lightText),
                  decoration: const InputDecoration(hintText: 'Ex: 50mg • 1 comprimido', prefixIcon: Icon(Icons.straighten, size: 20)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a dosagem' : null,
                ),
                const SizedBox(height: 16),
                _label('Horário'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.access_time, size: 20),
                    ),
                    child: Text(
                      _time == null ? 'Selecionar horário' : _timeLabel,
                      style: TextStyle(
                        color: _time == null ? AppColors.lightTextSecondary : AppColors.lightText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (_time == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 6, left: 12),
                    child: Text('Selecione o horário do lembrete', style: TextStyle(color: AppColors.emergencyRed, fontSize: 12)),
                  ),
                const SizedBox(height: 16),
                _label('Período'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: medicationPeriods.map((p) {
                    final selected = p == _period;
                    return ChoiceChip(
                      label: Text(p),
                      selected: selected,
                      onSelected: (_) => setState(() => _period = p),
                      selectedColor: AppColors.primaryBlue,
                      backgroundColor: AppColors.lightBackground,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: selected ? AppColors.primaryBlue : AppColors.lightDivider),
                      ),
                    );
                  }).toList(),
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Salvar'),
                      ),
                    ),
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
