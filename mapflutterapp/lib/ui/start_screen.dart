import 'package:flutter/material.dart';
import 'package:mapflutterapp/ui/home_page.dart';
import 'package:provider/provider.dart';
import 'sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    @override
    final User? user = Provider.of<User?>(context);

    if (user != null) {
      return HomePage();
    } else {
    
    return Scaffold(
      // 1) white background for everything below the status-bar
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2) Blue header (unchanged)
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: const Text(
                'Namibia\nHockey Union',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),

            // 3) Logo fills full width, keeps its aspect ratio
            Expanded(
              child: Image.asset(
                'assets/logo.jpg',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
            ),

            // 4) “Get Started” button pinned to the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    }
  }
}
