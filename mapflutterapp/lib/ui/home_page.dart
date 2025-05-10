import 'package:flutter/material.dart';
import 'team_registration_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _menuButton(BuildContext context, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,                  // fixed height for every button
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,   // body is white
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Blue header ───────────────────────────────────
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: const Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ─── Buttons on white backdrop ──────────────────────
            // Use a Column of fixed-height rows, each separated by a thin divider
            _menuButton(context, 'Teams', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamRegistrationScreen()),
              );
            }),
            const Divider(height: 1, color: Colors.grey),
            _menuButton(context, 'Events', () {/*navigate*/}),
            const Divider(height: 1, color: Colors.grey),
            _menuButton(context, 'Players', () {/*navigate*/}),
            const Divider(height: 1, color: Colors.grey),
            _menuButton(context, 'View Liveupdates', () {/*navigate*/}),
            const Divider(height: 1, color: Colors.grey),

            // ─── Push everything up, no stretching ───────────────
          ],
        ),
      ),
    );
  }
}
