import 'package:flutter/material.dart';

class TeamRegistrationScreen extends StatelessWidget {
  const TeamRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to team registration form
              },
              child: const Text('Register New Team'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Registered Teams:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with the actual number of teams
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Team ${index + 1}'), // Replace with team name
                    onTap: () {
                      // Handle team selection
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
