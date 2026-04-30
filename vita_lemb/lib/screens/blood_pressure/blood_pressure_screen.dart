import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/mock_data.dart';
import '../medications/medications_screen.dart';
import '../accessibility/accessibility_screen.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final _systolicCtrl = TextEditingController(text: '138');
  final _diastolicCtrl = TextEditingController(text: '88');
  bool _saved = false;

  void _onNavTap(int index) {
    if (index == 3) return;
    Widget? target;
    if (index == 1) target = const MedicationsScreen();
    if (index == 2) target = const AccessibilityScreen();
    if (index == 0) Navigator.popUntil(context, (r) => r.isFirst);
    if (target != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target!));
  }

  @override
  void dispose() {
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navyBlue, AppColors.darkNavy],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    const Text('🩺', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    const Text('Pressão Arterial', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NewMeasurementCard(
                        systolicCtrl: _systolicCtrl,
                        diastolicCtrl: _diastolicCtrl,
                        saved: _saved,
                        onSave: () => setState(() => _saved = true),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'ÚLTIMOS 7 DIAS',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      _BpChart(),
                      const SizedBox(height: 20),
                      const Text(
                        'MEDIÇÕES',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 12),
                      ...mockBpReadings.map((r) => _ReadingTile(reading: r)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 3, onTap: _onNavTap),
    );
  }
}

class _NewMeasurementCard extends StatelessWidget {
  final TextEditingController systolicCtrl;
  final TextEditingController diastolicCtrl;
  final bool saved;
  final VoidCallback onSave;

  const _NewMeasurementCard({
    required this.systolicCtrl,
    required this.diastolicCtrl,
    required this.saved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nova medição', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _BpInput(label: 'SISTÓLICA', controller: systolicCtrl)),
              const SizedBox(width: 12),
              Expanded(child: _BpInput(label: 'DIASTÓLICA', controller: diastolicCtrl)),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: saved ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: saved ? AppColors.successGreen : AppColors.primaryBlue,
            ),
            child: Text(saved ? '✓ Salvo!' : 'Salvar Medição'),
          ),
        ],
      ),
    );
  }
}

class _BpInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _BpInput({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            filled: true,
            fillColor: AppColors.darkNavy,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.divider)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.divider)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2)),
          ),
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
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Legend(color: AppColors.primaryBlue, label: 'Sistólica'),
              const SizedBox(width: 16),
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
                        return Text(labels[i], style: const TextStyle(color: AppColors.textSecondary, fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
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
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _ReadingTile extends StatelessWidget {
  final MockBpReading reading;
  const _ReadingTile({required this.reading});

  Color get _statusColor {
    switch (reading.status) {
      case 'Risco': return AppColors.riskTag;
      case 'Atenção': return AppColors.attentionTag;
      default: return AppColors.normalTag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reading.systolic}/${reading.diastolic}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(reading.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
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
