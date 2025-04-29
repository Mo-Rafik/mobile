import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final int employeeId;
  const ProfileScreen({super.key, required this.employeeId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Employee> _futureEmp;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _futureEmp = _api.fetchEmployee(widget.employeeId);
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value ?? "-",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
      ),
      body: FutureBuilder<Employee>(
        future: _futureEmp,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erreur : ${snap.error}'));
          }
          final emp = snap.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(Icons.person, size: 50, color: Colors.blueGrey),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${emp.nom} ${emp.prenom}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(emp.fonction, style: TextStyle(color: Colors.grey[700])),
                              Text(emp.email, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Personal Information place
                _buildSection("Informations Personnelles", [
                  _buildInfoRow(Icons.badge, "Matricule", emp.matricule),
                  _buildInfoRow(Icons.calendar_today, "Naissance", '${emp.dateNaissance} à ${emp.lieuNaissance}'),
                  _buildInfoRow(Icons.location_city, "Wilaya", emp.wilaya),
                  _buildInfoRow(Icons.person_outline, "Sexe", emp.sexe),
                  _buildInfoRow(Icons.flag, "Nationalité", emp.nationalite),
                  _buildInfoRow(Icons.phone, "Téléphone", emp.numTelephone),
                  _buildInfoRow(Icons.family_restroom, "Statut familial", emp.situationFamille),
                  _buildInfoRow(Icons.bloodtype, "Groupe sanguin", '${emp.groupeSanguin}${emp.rh}'),
                ]),

                // Professional Information place
                _buildSection("Informations Professionnelles", [
                  _buildInfoRow(Icons.work, "Fonction", emp.fonction),
                  _buildInfoRow(Icons.assignment_ind, "Poste", emp.poste),
                  _buildInfoRow(Icons.account_balance, "Département", emp.departement),
                  _buildInfoRow(Icons.school, "Formation (scolaire)", emp.formationScolaire),
                  _buildInfoRow(Icons.school_outlined, "Formation (pro)", emp.formationProfessionnelle),
                  _buildInfoRow(Icons.workspace_premium, "Qualification", emp.qualificationProfessionnelle),
                  _buildInfoRow(Icons.security, "Sécurité sociale", emp.numSecuSocial),
                  _buildInfoRow(Icons.military_tech, "Service national", emp.serviceNational),
                  _buildInfoRow(Icons.verified_user, "Statut", emp.statut),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
