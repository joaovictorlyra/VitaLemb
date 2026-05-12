import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'register_step3_screen.dart';

class RegisterStep2Screen extends StatefulWidget {
  const RegisterStep2Screen({super.key});

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  final _conditions = {'Hipertensão': true, 'Diabetes': false, 'Perda auditiva': false, 'Osteoporose': false};
  int _medCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Column(
        children: [
          _Step2Header(onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seu perfil de saúde',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.lightText),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Para personalizar seus lembretes',
                    style: TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Condições de saúde',
                    style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ..._conditions.entries.map((e) => _ConditionTile(
                        label: e.key,
                        checked: e.value,
                        onChanged: (v) => setState(() => _conditions[e.key] = v),
                      )),
                  const SizedBox(height: 24),
                  const Text(
                    'Remédios por dia',
                    style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['1-2', '3-5', '6+'].asMap().entries.map((e) {
                      final selected = _medCount == e.key;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _medCount = e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selected ? AppColors.primaryBlue : AppColors.lightCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected ? AppColors.primaryBlue : AppColors.lightDivider,
                              ),
                              boxShadow: selected
                                  ? [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))]
                                  : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))],
                            ),
                            child: Text(
                              e.value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: selected ? Colors.white : AppColors.lightTextSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterStep3Screen()),
                    ),
                    child: const Text('Continuar'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step2Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Step2Header({required this.onBack});

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
              Expanded(child: _stepIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepIndicator() {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < 2 ? Colors.white : Colors.white.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _ConditionTile({required this.label, required this.checked, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: checked ? AppColors.primaryBlue.withValues(alpha: 0.08) : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: checked ? AppColors.primaryBlue : AppColors.lightDivider,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: checked ? AppColors.primaryBlue : Colors.transparent,
                border: Border.all(
                  color: checked ? AppColors.primaryBlue : AppColors.lightTextSecondary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: AppColors.lightText, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
