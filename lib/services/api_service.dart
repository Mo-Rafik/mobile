import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visit.dart';

class ApiService {
  static const _baseUrl = 'http://127.0.0.1:8000';

  Future<List<Visit>> fetchHistoricVisits(int employeeId) async {
    final uri = Uri.parse('$_baseUrl/api/employes/$employeeId/historique-visites');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.map((e) => Visit.fromJson(e)).toList();
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }

  Future<List<Visit>> fetchFutureVisits(int employeeId) async {
    final uri = Uri.parse('$_baseUrl/api/employes/$employeeId/visites-futures');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.map((e) => Visit.fromJson(e)).toList();
    }
    throw Exception('Error ${resp.statusCode}: ${resp.body}');
  }
}
