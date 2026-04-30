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

class MockMedication {
  final String name;
  final String dosage;
  final String time;
  final bool taken;
  final String period;

  const MockMedication({
    required this.name,
    required this.dosage,
    required this.time,
    required this.taken,
    required this.period,
  });
}

const mockMedications = [
  MockMedication(name: 'Hidroclorotiazida', dosage: '25mg • 1 comprimido', time: '09:00', taken: true, period: 'MANHÃ'),
  MockMedication(name: 'Metoprolol', dosage: '50mg • 1 comprimido', time: '09:00', taken: true, period: 'MANHÃ'),
  MockMedication(name: 'Losartana', dosage: '50mg • 1 comprimido', time: '13:00', taken: false, period: 'ALMOÇO'),
  MockMedication(name: 'AAS', dosage: '100mg • 1 comprimido', time: '20:00', taken: false, period: 'NOITE'),
];

class MockBpReading {
  final String label;
  final int systolic;
  final int diastolic;
  final String status;

  const MockBpReading({
    required this.label,
    required this.systolic,
    required this.diastolic,
    required this.status,
  });
}

const mockBpReadings = [
  MockBpReading(label: 'Ontem 14:15', systolic: 155, diastolic: 98, status: 'Risco'),
  MockBpReading(label: 'Ontem 09:15', systolic: 183, diastolic: 62, status: 'Normal'),
  MockBpReading(label: '2 dias', systolic: 142, diastolic: 90, status: 'Atenção'),
  MockBpReading(label: '3 dias', systolic: 126, diastolic: 90, status: 'Normal'),
];

const mockChartSystolic = [138.0, 155.0, 183.0, 142.0, 126.0, 138.0, 140.0];
const mockChartDiastolic = [88.0, 98.0, 62.0, 90.0, 90.0, 85.0, 82.0];
