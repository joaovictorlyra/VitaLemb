import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../state/app_state.dart';
import '../../widgets/feedback.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Chamado pelo link "Ver todos" para trocar para a aba de Remédios.
  final VoidCallback? onSeeAllMeds;

  const HomeScreen({super.key, this.onSeeAllMeds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: ListenableBuilder(
        // Reconstrói quando perfil, remédios ou pressão mudam.
        listenable: Listenable.merge([profileStore, medicationStore, bpStore]),
        builder: (context, _) {
          return Column(
            children: [
              _Header(
                onProfileTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel(icon: '⚠️', title: 'EMERGÊNCIA'),
                      const SizedBox(height: 10),
                      const _EmergencyButton(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: _SectionLabel(icon: '💊', title: 'PRÓXIMO REMÉDIO')),
                          TextButton(
                            onPressed: onSeeAllMeds,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Ver todos →', style: TextStyle(color: AppColors.primaryBlue, fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _NextMedication(onSeeAll: onSeeAllMeds),
                      const SizedBox(height: 20),
                      const _SectionLabel(icon: '🩺', title: 'ÚLTIMA MEDIÇÃO'),
                      const SizedBox(height: 10),
                      // Não-const de propósito: precisa reconstruir quando o
                      // bpStore muda (nova medição salva).
                      _BpSummaryCard(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onProfileTap;
  const _Header({required this.onProfileTap});

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
                            Flexible(
                              child: Text(
                                profileStore.firstName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('👴', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Avatar abre a tela de perfil (editar dados / sair).
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Tooltip(
                      message: 'Meu perfil',
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(profileStore.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
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
  const _EmergencyButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.lightCard,
          title: const Text('Chamar Ajuda', style: TextStyle(color: AppColors.lightText)),
          content: Text(
            'Ligar para ${profileStore.emergencyName}\n${profileStore.emergencyPhone}?',
            style: const TextStyle(color: AppColors.lightTextSecondary),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                AppFeedback.success(context, 'Ligando para ${profileStore.emergencyName}...');
              },
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chamar Ajuda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Liga para seu contato de emergência', style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mostra somente o próximo remédio pendente (dashboard enxuto).
class _NextMedication extends StatelessWidget {
  final VoidCallback? onSeeAll;
  const _NextMedication({this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final next = medicationStore.nextPending;
    if (next == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.successGreen),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tudo em dia! Nenhum remédio pendente.',
                style: TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onSeeAll,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: const Border(left: BorderSide(color: AppColors.primaryBlue, width: 4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.lightBackground, borderRadius: BorderRadius.circular(10)),
              child: const Text('💊', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(next.name, style: const TextStyle(color: AppColors.lightText, fontWeight: FontWeight.w600, fontSize: 15)),
                  Text('${next.dosage} · ${next.time}', style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.warningOrange, borderRadius: BorderRadius.circular(20)),
              child: const Text('Pendente', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BpSummaryCard extends StatelessWidget {
  Color _statusColor(String status) {
    switch (status) {
      case 'Risco':
        return AppColors.riskTag;
      case 'Atenção':
        return AppColors.attentionTag;
      default:
        return AppColors.normalTag;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'Risco':
        return '⚠️ Alto';
      case 'Atenção':
        return '⚠️ Levemente Alto';
      default:
        return '✓ Normal';
    }
  }

  @override
  Widget build(BuildContext context) {
    final latest = bpStore.latest;
    final color = _statusColor(latest.status);
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
              Text(
                '${latest.systolic}/${latest.diastolic}',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(latest.status),
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Text('mmHg', style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(latest.label, style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
