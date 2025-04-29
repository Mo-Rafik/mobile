// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class ApiService {
  //   adb reverse tcp:8000 tcp:8000 t3 usb
  // ayat le serveur
  static const _baseUrl = 'http://127.0.0.1:8000';

  Future<Employee> fetchEmployee(int id) async {
    final uri = Uri.parse('$_baseUrl/api/employes/$id');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      return Employee.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }
  }
}
