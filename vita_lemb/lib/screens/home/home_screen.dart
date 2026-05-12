import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/mock_data.dart';
import '../medications/medications_screen.dart';
import '../blood_pressure/blood_pressure_screen.dart';
import '../accessibility/accessibility_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    Widget target;
    switch (index) {
      case 1:
        target = const MedicationsScreen();
        break;
      case 2:
        target = const AccessibilityScreen();
        break;
      case 3:
        target = const BloodPressureScreen();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(icon: '⚠️', title: 'EMERGÊNCIA'),
                  const SizedBox(height: 10),
                  _EmergencyButton(),
                  const SizedBox(height: 20),
                  _SectionLabel(icon: '💊', title: 'PRÓXIMOS REMÉDIOS'),
                  const SizedBox(height: 10),
                  _MedicationCard(
                    name: 'Losartana',
                    dosage: '25mg',
                    detail: '1 comprimido · 08:00',
                    confirmed: false,
                  ),
                  const SizedBox(height: 10),
                  _MedicationCard(
                    name: 'Hidroclorotiazida',
                    dosage: '25mg',
                    detail: '1 comprimido · 12:00',
                    confirmed: true,
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel(icon: '🩺', title: 'ÚLTIMA MEDIÇÃO'),
                  const SizedBox(height: 10),
                  _BpSummaryCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
    );
  }
}

class _Header extends StatelessWidget {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bom dia,',
                          style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            Text(
                              MockUser.name,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            const Text('👴', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Text('JS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('📅', style: TextStyle(fontSize: 13)),
                    SizedBox(width: 6),
                    Text(
                      'Domingo, 3 de maio',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String icon;
  final String title;
  const _SectionLabel({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.lightTextSecondary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.lightCard,
          title: const Text('Chamar Ajuda', style: TextStyle(color: AppColors.lightText)),
          content: const Text(
            'Ligar para Maria Silva\n(71) 9999-9999?',
            style: TextStyle(color: AppColors.lightTextSecondary),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
              child: const Text('Ligar'),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.emergencyRed,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.emergencyRed.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('🆘', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chamar Ajuda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Liga para seu contato de emergência', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String detail;
  final bool confirmed;

  const _MedicationCard({
    required this.name,
    required this.dosage,
    required this.detail,
    required this.confirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(
            color: confirmed ? AppColors.successGreen : AppColors.primaryBlue,
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
                Text(
                  '$name $dosage',
                  style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600, fontSize: 15),
                ),
                Text(detail, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
              ],
            ),
          ),
          if (confirmed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('✓ OK', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.warningOrange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Pendente', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class _BpSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '138/88',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.warningOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '⚠️ Levemente Alto',
                  style: TextStyle(color: AppColors.warningOrange, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Text('mmHg', style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          const Text('Hoje às 08:15', style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
