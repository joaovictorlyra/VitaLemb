// Dados de exemplo que servem de "semente" para os stores em memória.
// O app é um protótipo de UI/UX: não há backend, então o estado vive em
// memória (ver `lib/state/app_state.dart`) e é inicializado a partir daqui.

/// Valores padrão do usuário e do contato de emergência.
class MockUser {
  static const name = 'João Silva';
  static const phone = '(71) 9999-9999';
  static const birthDate = '15/03/1952';
}

class MockEmergencyContact {
  static const name = 'Maria Silva';
  static const phone = '(71) 9999-9999';
  static const relation = 'Cônjuge';
}

/// Períodos do dia na ordem em que devem aparecer agrupados.
const medicationPeriods = ['MANHÃ', 'ALMOÇO', 'TARDE', 'NOITE'];

/// Modelo mutável de medicamento (editável em memória).
class Medication {
  String name;
  String dosage;
  String time;
  bool taken;
  String period;

  Medication({
    required this.name,
    required this.dosage,
    required this.time,
    required this.taken,
    required this.period,
  });
}

List<Medication> seedMedications() => [
      Medication(name: 'Hidroclorotiazida', dosage: '25mg • 1 comprimido', time: '09:00', taken: true, period: 'MANHÃ'),
      Medication(name: 'Metoprolol', dosage: '50mg • 1 comprimido', time: '09:00', taken: true, period: 'MANHÃ'),
      Medication(name: 'Losartana', dosage: '50mg • 1 comprimido', time: '13:00', taken: false, period: 'ALMOÇO'),
      Medication(name: 'AAS', dosage: '100mg • 1 comprimido', time: '20:00', taken: false, period: 'NOITE'),
    ];

/// Modelo de medição de pressão.
class BpReading {
  final String label;
  final int systolic;
  final int diastolic;
  final String status;

  const BpReading({
    required this.label,
    required this.systolic,
    required this.diastolic,
    required this.status,
  });
}

List<BpReading> seedBpReadings() => const [
      BpReading(label: 'Ontem 14:15', systolic: 155, diastolic: 98, status: 'Risco'),
      BpReading(label: 'Ontem 09:15', systolic: 183, diastolic: 62, status: 'Normal'),
      BpReading(label: '2 dias', systolic: 142, diastolic: 90, status: 'Atenção'),
      BpReading(label: '3 dias', systolic: 126, diastolic: 90, status: 'Normal'),
    ];

const mockChartSystolic = [138.0, 155.0, 183.0, 142.0, 126.0, 138.0, 140.0];
const mockChartDiastolic = [88.0, 98.0, 62.0, 90.0, 90.0, 85.0, 82.0];
