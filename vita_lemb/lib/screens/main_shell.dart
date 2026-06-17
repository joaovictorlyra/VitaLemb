import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/home_screen.dart';
import 'medications/medications_screen.dart';
import 'accessibility/accessibility_screen.dart';
import 'blood_pressure/blood_pressure_screen.dart';

/// Casca de navegação principal do app.
///
/// Mantém as 4 abas vivas em um [IndexedStack] (estado preservado, troca
/// instantânea) e é a única dona da navegação por abas. As telas internas não
/// empilham mais umas às outras — isso evita o crescimento da pilha e o
/// "ficar preso" relatado na avaliação.
class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  void _select(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeScreen(onSeeAllMeds: () => _select(1)),
      const MedicationsScreen(),
      const AccessibilityScreen(),
      const BloodPressureScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: AppBottomNavBar(currentIndex: _index, onTap: _select),
    );
  }
}
