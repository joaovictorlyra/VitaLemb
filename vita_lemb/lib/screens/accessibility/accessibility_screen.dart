import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../models/mock_data.dart';
import '../medications/medications_screen.dart';
import '../blood_pressure/blood_pressure_screen.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _fontSize = true;
  bool _highContrast = false;
  bool _vibration = true;
  bool _loudSound = true;
  bool _flashAlert = true;
  bool _biometric = false;
  bool _shareDoctor = true;

  void _onNavTap(int index) {
    if (index == 2) return;
    Widget? target;
    if (index == 1) target = const MedicationsScreen();
    if (index == 3) target = const BloodPressureScreen();
    if (index == 0) Navigator.popUntil(context, (r) => r.isFirst);
    if (target != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => target!));
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
                    const Text('⚙️', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    const Text('Acessibilidade', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _SectionHeader(title: 'CONTATO DE EMERGÊNCIA'),
                    _EmergencyContactTile(),
                    _SectionHeader(title: 'TEXTO E LEITURA'),
                    _ToggleTile(label: 'Tamanho da Fonte', value: _fontSize, onChanged: (v) => setState(() => _fontSize = v)),
                    _ToggleTile(label: 'Alto Contraste', value: _highContrast, onChanged: (v) => setState(() => _highContrast = v)),
                    _SectionHeader(title: 'ALERTAS'),
                    _ToggleTile(label: 'Vibração', value: _vibration, onChanged: (v) => setState(() => _vibration = v)),
                    _ToggleTile(label: 'Som Alto', value: _loudSound, onChanged: (v) => setState(() => _loudSound = v)),
                    _ToggleTile(label: 'Alerta Visual (Flash)', value: _flashAlert, onChanged: (v) => setState(() => _flashAlert = v)),
                    _SectionHeader(title: 'SEGURANÇA'),
                    _ToggleTile(label: 'Acesso com Digital', value: _biometric, onChanged: (v) => setState(() => _biometric = v)),
                    _ToggleTile(label: 'Compartilhar com Médico', value: _shareDoctor, onChanged: (v) => setState(() => _shareDoctor = v)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 2, onTap: _onNavTap),
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
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _EmergencyContactTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryBlue.withOpacity(0.3),
            child: const Text('MS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(MockEmergencyContact.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                Text(MockEmergencyContact.relation, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.successGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.phone, color: AppColors.successGreen, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withOpacity(0.4),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.divider,
          ),
        ],
      ),
    );
  }
}
