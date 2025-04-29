//home_page_ui
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A90E2),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => _navigate(context, const ProfileScreen()),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(255, 255, 255, 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha(80),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person, color: Color(0xFF4A90E2), size: 28),
            ),
          ),
        ),
        title: const Text('Accueil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, size: 28, color: Colors.white),
            onPressed: () => _navigate(context, const ChatScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28, color: Colors.white),
            onPressed: () => _navigate(context, const NotificationsScreen()),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _AnimatedBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _AnimatedMenuCard(
                    icon: Icons.folder_open,
                    label: 'Dossier médical',
                    color: const Color(0xFF4A90E2),
                    onTap: () => _navigate(context, const MedicalRecordScreen()),
                  ),
                  _AnimatedMenuCard(
                    icon: Icons.description,
                    label: 'Documents médicaux',
                    color: const Color(0xFF5AA9E6),
                    onTap: () => _navigate(context, const DocumentScreen()),
                  ),
                  _AnimatedMenuCard(
                    icon: Icons.calendar_today,
                    label: 'Visites médicales',
                    color: const Color(0xFF7EC8E3),
                    onTap: () => _navigate(context, const VisitsScreen()),
                  ),
                  _AnimatedMenuCard(
                    icon: Icons.track_changes,
                    label: 'Suivi santé',
                    color: const Color(0xFF9BE3DE),
                    onTap: () => _navigate(context, const HealthTrackScreen()),
                  ),
                  _AnimatedMenuCard(
                    icon: Icons.medication,
                    label: 'Médicaments',
                    color: const Color(0xFF50E3C2),
                    onTap: () => _navigate(context, const MedicationScreen()),
                  ),
                ]
                    .animate(interval: 80.ms)
                    .fadeIn(duration: 500.ms)
                    .slide(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                      curve: Curves.easeOut,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => screen,
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: anim,
              curve: Curves.easeInOutQuart,
            )),
            child: FadeTransition(opacity: anim, child: child),
          );
        },
      ),
    );
  }
}

class _AnimatedMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _AnimatedMenuCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(80),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: color.withAlpha(30),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withAlpha(100), width: 2),
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          color: Colors.blue.shade900,
                        ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(255, 255, 255, 0.1),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(duration: 3000.ms, curve: Curves.easeInOut)
              .then(delay: 500.ms)
              .scale(end: const Offset(1.5, 1.5)), 
        ),
        Positioned(
          bottom: -80,
          left: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromRGBO(255, 255, 255, 0.1),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(duration: 4000.ms, curve: Curves.easeInOut)
              .then(delay: 1000.ms)
              .scale(end: const Offset(1.8, 1.8)), 
        ),
      ],
    );
  }
}

// Placeholder Screens
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Profil');
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Chat');
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Notifications');
}

class MedicalRecordScreen extends StatelessWidget {
  const MedicalRecordScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Dossier Médical');
}

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Documents Médicaux');
}

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Visites Médicales');
}

class HealthTrackScreen extends StatelessWidget {
  const HealthTrackScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Suivi de Santé');
}

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});
  @override
  Widget build(BuildContext context) => _Placeholder(title: 'Médicaments');
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Contenu de $title',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
