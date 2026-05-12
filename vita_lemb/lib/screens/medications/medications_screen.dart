import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/mock_data.dart';
import '../blood_pressure/blood_pressure_screen.dart';
import '../accessibility/accessibility_screen.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final _taken = {0: true, 1: true, 2: false, 3: false};

  void _onNavTap(int index) {
    if (index == 1) return;
    Widget? target;
    if (index == 3) target = const BloodPressureScreen();
    if (index == 2) target = const AccessibilityScreen();
    if (index == 0) Navigator.popUntil(context, (r) => r.isFirst);
    if (target != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target!));
  }

  @override
  Widget build(BuildContext context) {
    final takenCount = _taken.values.where((v) => v).length;
    final total = mockMedications.length;
    final groups = <String, List<int>>{};
    for (var i = 0; i < mockMedications.length; i++) {
      groups.putIfAbsent(mockMedications[i].period, () => []).add(i);
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MedicationsHeader(takenCount: takenCount, total: total),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
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
                    ...group.value.map((i) => _MedTile(
                          med: mockMedications[i],
                          taken: _taken[i] ?? false,
                          onToggle: () => setState(() => _taken[i] = !(_taken[i] ?? false)),
                        )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 1, onTap: _onNavTap),
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
  final MockMedication med;
  final bool taken;
  final VoidCallback onToggle;

  const _MedTile({required this.med, required this.taken, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              color: taken ? AppColors.successGreen : AppColors.primaryBlue,
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
                color: taken ? AppColors.successGreen : Colors.transparent,
                border: Border.all(
                  color: taken ? AppColors.successGreen : AppColors.lightTextSecondary,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: taken ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
