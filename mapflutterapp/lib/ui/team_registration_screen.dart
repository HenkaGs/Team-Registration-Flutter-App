import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/team.dart';
import 'create_team_screen.dart';

class TeamRegistrationScreen extends StatelessWidget {
  const TeamRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
                );
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
              child: StreamBuilder<List<Team>>(
                stream: firestoreService.getTeams(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading teams'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No teams registered'));
                  }

                  final teams = snapshot.data!;
                  return ListView.builder(
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return ListTile(
                        title: Text(team.name),
                        subtitle: Text('Coach: ${team.coach}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await firestoreService.deleteTeam(team.id);
                          },
                        ),
                        onTap: () {
                          // Handle team selection or editing
                        },
                      );
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
