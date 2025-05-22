import 'package:flutter/material.dart';
import 'team_registration_screen.dart';
import '../firebase_service.dart';
import 'start_screen.dart';
import 'player_management_screen.dart';
import 'events_screen.dart';
import 'live_updates_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _menuButton(
    BuildContext context,
    String text,
    VoidCallback onTap, {
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue header with curved bottom edges
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF002B7F), // deep Namibian blue
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: const Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Menu Buttons
            _menuButton(
              context,
              'Teams',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamRegistrationScreen(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              textColor: const Color(0xFF002B7F),
            ),
            _menuButton(
              context,
              'Events',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EventsScreen(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              textColor: const Color(0xFF002B7F),
            ),
            _menuButton(
              context,
              'Players',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerManagementScreen(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              textColor: const Color(0xFF002B7F),
            ),
            _menuButton(
              context,
              'View Liveupdates',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveUpdatesScreen(),
                  ),
                );
              },
              backgroundColor: Colors.white,
              textColor: const Color(0xFF002B7F),
            ),
            _menuButton(
              context,
              'Log Out',
              () async {
                final authService = AuthService();
                await authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartScreen(),
                  ),
                  (route) => false,
                );
              },
              backgroundColor: const Color(0xFFC8102E), // Namibian flag red
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}