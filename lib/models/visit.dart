class Visit {
  final int id;
  final DateTime dateVisite;
  final int medecinId;
  final int employeId;
  final String type;
  final int cmsId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? prescriptions;
  final String? observations;

  Visit({
    required this.id,
    required this.dateVisite,
    required this.medecinId,
    required this.employeId,
    required this.type,
    required this.cmsId,
    required this.createdAt,
    required this.updatedAt,
    this.prescriptions,
    this.observations,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      dateVisite: DateTime.parse(json['dateVisite']),
      medecinId: json['MedecinId'],
      employeId: json['EmployeId'],
      type: json['type'],
      cmsId: json['cms_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      prescriptions: json['prescriptions'],
      observations: json['observations'],
    );
  }
}
