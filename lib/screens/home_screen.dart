// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final int currentEmployeeId = 2;

  const HomeScreen({super.key}); //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(employeeId: currentEmployeeId),
              ),
            );
          },
        ),
      ),
      body: Center(child: Text('Bienvenue!')),
    );
  }
}
