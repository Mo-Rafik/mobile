import 'package:flutter/material.dart';

import '../models/visit.dart';
import '../services/api_service.dart';

class VisitHistoryScreen extends StatefulWidget {
  final int employeeId;
  const VisitHistoryScreen({super.key, required this.employeeId});

  @override
  _VisitHistoryScreenState createState() => _VisitHistoryScreenState();
}

class _VisitHistoryScreenState extends State<VisitHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildVisitList(Future<List<Visit>> futureVisits) {
    return FutureBuilder<List<Visit>>(
      future: futureVisits,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}', style: TextStyle(color: Colors.redAccent)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune visite', style: TextStyle(fontSize: 16, color: Colors.grey)));
        }
        final visits = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemCount: visits.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final visit = visits[index];
            final date = visit.dateVisite.toLocal().toIso8601String().split('T').first;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              shadowColor: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left accent bar
                    Container(width: 4, height: 60, decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 12),

                    // Main content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${visit.type} — $date',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text('Médecin ID: ${visit.medecinId}', style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 4),
                          Text('Prescriptions: ${visit.prescriptions ?? "Aucune"}', style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 4),
                          Text('Observations: ${visit.observations ?? "Aucune"}', style: TextStyle(color: Colors.grey[700])),
                        ],
                      ),
                    ),

                    // CMS badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('CMS #${visit.cmsId}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique & À venir'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Historique'),
            Tab(text: 'À venir'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVisitList(_apiService.fetchHistoricVisits(widget.employeeId)),
          _buildVisitList(_apiService.fetchFutureVisits(widget.employeeId)),
        ],
      ),
    );
  }
}
