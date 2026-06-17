import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/mock_data.dart';
import '../../state/app_state.dart';
import '../../widgets/feedback.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicCtrl = TextEditingController();
  final _diastolicCtrl = TextEditingController();
  bool _justSaved = false;

  @override
  void dispose() {
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      AppFeedback.warning(context, 'Verifique os valores informados');
      return;
    }
    final systolic = int.parse(_systolicCtrl.text.trim());
    final diastolic = int.parse(_diastolicCtrl.text.trim());
    bpStore.add(systolic: systolic, diastolic: diastolic, label: 'Agora');
    setState(() => _justSaved = true);
    AppFeedback.success(context, 'Medição $systolic/$diastolic registrada');
    FocusScope.of(context).unfocus();
  }

  void _clear() {
    _systolicCtrl.clear();
    _diastolicCtrl.clear();
    setState(() => _justSaved = false);
    _formKey.currentState?.reset();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _BpHeader(),
          Expanded(
            child: ListenableBuilder(
              listenable: bpStore,
              builder: (context, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: _NewMeasurementCard(
                          systolicCtrl: _systolicCtrl,
                          diastolicCtrl: _diastolicCtrl,
                          justSaved: _justSaved,
                          onSave: _save,
                          onClear: _clear,
                          onChanged: () {
                            if (_justSaved) setState(() => _justSaved = false);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'ÚLTIMOS 7 DIAS',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.lightTextSecondary, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      _BpChart(),
                      const SizedBox(height: 20),
                      const Text(
                        'MEDIÇÕES',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.lightTextSecondary, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      ...bpStore.readings.map((r) => _ReadingTile(reading: r)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BpHeader extends StatelessWidget {
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
              Text('🩺', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Text('Pressão Arterial', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewMeasurementCard extends StatelessWidget {
  final TextEditingController systolicCtrl;
  final TextEditingController diastolicCtrl;
  final bool justSaved;
  final VoidCallback onSave;
  final VoidCallback onClear;
  final VoidCallback onChanged;

  const _NewMeasurementCard({
    required this.systolicCtrl,
    required this.diastolicCtrl,
    required this.justSaved,
    required this.onSave,
    required this.onClear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nova medição', style: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _BpInput(label: 'SISTÓLICA', controller: systolicCtrl, max: 250, min: 70, onChanged: onChanged)),
              const SizedBox(width: 12),
              Expanded(child: _BpInput(label: 'DIASTÓLICA', controller: diastolicCtrl, max: 150, min: 40, onChanged: onChanged)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onClear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.lightTextSecondary,
                    side: const BorderSide(color: AppColors.lightDivider),
                    minimumSize: const Size(0, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Limpar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: justSaved ? AppColors.successGreen : AppColors.primaryBlue,
                  ),
                  child: Text(justSaved ? '✓ Salvo!' : 'Salvar Medição'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BpInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int min;
  final int max;
  final VoidCallback onChanged;

  const _BpInput({
    required this.label,
    required this.controller,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 11, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
          onChanged: (_) => onChanged(),
          style: const TextStyle(color: AppColors.lightText, fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '—',
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            filled: true,
            fillColor: AppColors.lightBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.lightDivider)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.lightDivider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2)),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Obrigatório';
            final n = int.tryParse(v.trim());
            if (n == null) return 'Inválido';
            if (n < min || n > max) return '$min–$max';
            return null;
          },
        ),
      ],
    );
  }
}

class _BpChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              _Legend(color: AppColors.primaryBlue, label: 'Sistólica'),
              SizedBox(width: 16),
              _Legend(color: AppColors.successGreen, label: 'Diastólica'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 200,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = ['D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'D-1', 'Hj'];
                        final i = v.toInt();
                        if (i < 0 || i >= labels.length) return const SizedBox();
                        return Text(labels[i], style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: mockChartSystolic[i],
                        color: AppColors.primaryBlue,
                        width: 8,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: mockChartDiastolic[i],
                        color: AppColors.successGreen,
                        width: 8,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 11)),
      ],
    );
  }
}

class _ReadingTile extends StatelessWidget {
  final BpReading reading;
  const _ReadingTile({required this.reading});

  Color get _statusColor {
    switch (reading.status) {
      case 'Risco':
        return AppColors.riskTag;
      case 'Atenção':
        return AppColors.attentionTag;
      default:
        return AppColors.normalTag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reading.systolic}/${reading.diastolic}',
                  style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(reading.label, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              reading.status,
              style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
