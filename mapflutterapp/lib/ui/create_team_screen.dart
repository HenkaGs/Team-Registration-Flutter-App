import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_service.dart';
import '../models/team.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _coachNameController = TextEditingController();
  final List<TextEditingController> _playerControllers = [];
  final FirestoreService _firestoreService = FirestoreService();

  void _addPlayerField() {
    setState(() {
      _playerControllers.add(TextEditingController());
    });
  }

  void _removePlayerField(int index) {
    setState(() {
      _playerControllers.removeAt(index);
    });
  }

  Future<void> _createTeam() async {
    final players = _playerControllers.map((controller) => controller.text).toList();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not logged in.')),
      );
      return;
    }

    final newTeam = Team(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _teamNameController.text,
      coach: _coachNameController.text,
      players: players,
      userId: userId,
    );
    await _firestoreService.createTeam(newTeam);
    Navigator.pop(context); // Navigate back to the Team Registration screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _coachNameController,
              decoration: const InputDecoration(
                labelText: 'Coach Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Players:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _playerControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _playerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Player ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removePlayerField(index),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addPlayerField,
              child: const Text('Add Player'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createTeam,
              child: const Text('Create Team'),
            ),
          ],
        ),
      ),
    );
  }
}
