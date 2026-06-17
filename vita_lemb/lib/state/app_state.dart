import 'package:flutter/foundation.dart';
import '../models/mock_data.dart';

// Estado em memória do protótipo. Sem persistência: ao reiniciar o app,
// tudo volta às sementes de `mock_data.dart`. As telas escutam via
// `ListenableBuilder` e se reconstroem quando algo muda.

/// Medicamentos do dia: adicionar, remover e marcar como tomado.
class MedicationStore extends ChangeNotifier {
  final List<Medication> _items = seedMedications();

  List<Medication> get items => List.unmodifiable(_items);
  int get total => _items.length;
  int get takenCount => _items.where((m) => m.taken).length;

  /// O próximo remédio pendente (para o resumo do dashboard).
  Medication? get nextPending {
    for (final m in _items) {
      if (!m.taken) return m;
    }
    return null;
  }

  /// Itens agrupados por período, na ordem de `medicationPeriods`.
  Map<String, List<Medication>> get grouped {
    final map = <String, List<Medication>>{};
    for (final period in medicationPeriods) {
      final inPeriod = _items.where((m) => m.period == period).toList();
      if (inPeriod.isNotEmpty) map[period] = inPeriod;
    }
    // períodos fora da lista padrão (caso surjam) vão por último
    for (final m in _items) {
      if (!medicationPeriods.contains(m.period)) {
        map.putIfAbsent(m.period, () => []).add(m);
      }
    }
    return map;
  }

  void add(Medication med) {
    _items.add(med);
    notifyListeners();
  }

  /// Insere em uma posição específica (usado pelo "Desfazer").
  void insertAt(int index, Medication med) {
    _items.insert(index.clamp(0, _items.length), med);
    notifyListeners();
  }

  int indexOf(Medication med) => _items.indexOf(med);

  void remove(Medication med) {
    _items.remove(med);
    notifyListeners();
  }

  void toggle(Medication med) {
    med.taken = !med.taken;
    notifyListeners();
  }
}

/// Medições de pressão arterial.
class BpStore extends ChangeNotifier {
  final List<BpReading> _readings = seedBpReadings();

  List<BpReading> get readings => List.unmodifiable(_readings);

  /// A medição mais recente (topo da lista), para o resumo do dashboard.
  BpReading get latest => _readings.first;

  /// Classifica a pressão de forma simples para o protótipo.
  static String classify(int systolic, int diastolic) {
    if (systolic >= 160 || diastolic >= 100) return 'Risco';
    if (systolic >= 140 || diastolic >= 90) return 'Atenção';
    return 'Normal';
  }

  void add({required int systolic, required int diastolic, required String label}) {
    _readings.insert(
      0,
      BpReading(
        label: label,
        systolic: systolic,
        diastolic: diastolic,
        status: classify(systolic, diastolic),
      ),
    );
    notifyListeners();
  }
}

/// Dados do usuário (editáveis no Perfil).
class ProfileStore extends ChangeNotifier {
  String name = MockUser.name;
  String phone = MockUser.phone;
  String birthDate = MockUser.birthDate;

  String emergencyName = MockEmergencyContact.name;
  String emergencyPhone = MockEmergencyContact.phone;
  String emergencyRelation = MockEmergencyContact.relation;

  /// Iniciais para o avatar (ex.: "João Silva" -> "JS").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  /// Primeiro nome, para saudações.
  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  void update({required String name, required String phone, required String birthDate}) {
    this.name = name;
    this.phone = phone;
    this.birthDate = birthDate;
    notifyListeners();
  }

  void updateEmergencyContact({required String name, required String phone, required String relation}) {
    emergencyName = name;
    emergencyPhone = phone;
    emergencyRelation = relation;
    notifyListeners();
  }
}

/// Cuidador vinculado ao paciente (seção em Config).
class CaregiverStore extends ChangeNotifier {
  String? name;
  String? relation;
  String? phone;
  bool sharingEnabled = true;

  bool get hasCaregiver => name != null && name!.isNotEmpty;

  void save({required String name, required String relation, required String phone}) {
    this.name = name;
    this.relation = relation;
    this.phone = phone;
    notifyListeners();
  }

  void setSharing(bool value) {
    sharingEnabled = value;
    notifyListeners();
  }

  void remove() {
    name = null;
    relation = null;
    phone = null;
    notifyListeners();
  }
}

/// Preferências de acessibilidade que afetam o app inteiro.
class SettingsStore extends ChangeNotifier {
  bool largeFont = false;
  bool highContrast = false;

  /// Fator aplicado ao `textScaler` global em `main.dart`.
  double get textScale => largeFont ? 1.3 : 1.0;

  void setLargeFont(bool value) {
    largeFont = value;
    notifyListeners();
  }
}

// Instâncias singleton usadas em todo o app.
final medicationStore = MedicationStore();
final bpStore = BpStore();
final profileStore = ProfileStore();
final caregiverStore = CaregiverStore();
final settingsStore = SettingsStore();
