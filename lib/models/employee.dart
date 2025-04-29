// models/employee.dart
class Employee {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String numTelephone;
  final String matricule;
  final String dateNaissance;
  final String lieuNaissance;
  final String wilayaNaissance;
  final String adresse;
  final String wilaya;
  final String sexe;
  final String nationalite;
  final String fonction;
  final String poste;
  final String departement;
  final String situationFamille;
  final String groupeSanguin;
  final String rh;
  final String formationScolaire;
  final String formationProfessionnelle;
  final String qualificationProfessionnelle;
  final String numSecuSocial;
  final String serviceNational;
  final String statut;

  Employee({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.numTelephone,
    required this.matricule,
    required this.dateNaissance,
    required this.lieuNaissance,
    required this.wilayaNaissance,
    required this.adresse,
    required this.wilaya,
    required this.sexe,
    required this.nationalite,
    required this.fonction,
    required this.poste,
    required this.departement,
    required this.situationFamille,
    required this.groupeSanguin,
    required this.rh,
    required this.formationScolaire,
    required this.formationProfessionnelle,
    required this.qualificationProfessionnelle,
    required this.numSecuSocial,
    required this.serviceNational,
    required this.statut,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      email: json['email'] as String,
      numTelephone: json['numTelephone'] as String,
      matricule: json['matricule'] as String,
      dateNaissance: json['dateNaissance'] as String,
      lieuNaissance: json['lieuNaissance'] as String,
      wilayaNaissance: json['wilayaNaissance'] as String,
      adresse: json['adresse'] as String,
      wilaya: json['wilaya'] as String,
      sexe: json['sexe'] as String,
      nationalite: json['nationalite'] as String,
      fonction: json['fonction'] as String,
      poste: json['poste'] as String,
      departement: json['departement'] as String,
      situationFamille: json['situationFamille'] as String,
      groupeSanguin: json['groupeSanguin'] as String,
      rh: json['rh'] as String,
      formationScolaire: json['formationScolaire'] as String,
      formationProfessionnelle: json['formationProfessionnelle'] as String,
      qualificationProfessionnelle: json['qualificationProfessionnelle'] as String,
      numSecuSocial: json['numSecuSocial'] as String,
      serviceNational: json['serviceNational'] as String,
      statut: json['statut'] as String,
    );
  }
}
