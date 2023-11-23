class AcademicAbility {
  // Defina os campos necessários na sua classe modelo
  final int activeCheckIns;
  final int capacity;

  AcademicAbility({required this.activeCheckIns, required this.capacity});

  // Adicione um método de fábrica para converter JSON em uma instância da classe modelo
  factory AcademicAbility.fromJson(Map<String, dynamic> json) {
    return AcademicAbility(
      activeCheckIns: json['active_check_ins'],
      capacity: json['capacity'],
      // Adicione outros campos conforme necessário
    );
  }
}
