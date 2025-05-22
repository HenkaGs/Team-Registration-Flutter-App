import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/team.dart';
import '../models/player.dart';

class EditTeamScreen extends StatefulWidget {
  final Team team;

  const EditTeamScreen({super.key, required this.team});

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  late TextEditingController _teamNameController;
  late TextEditingController _coachNameController;
  late TextEditingController _contactNameController;
  late TextEditingController _contactEmailController;
  late TextEditingController _contactPhoneController;

  final FirestoreService _firestoreService = FirestoreService();
  List<Player> _allPlayers = [];
  List<String> _selectedPlayerIds = [];

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.team.name);
    _coachNameController = TextEditingController(text: widget.team.coach);
    _contactNameController = TextEditingController(text: widget.team.contactName);
    _contactEmailController = TextEditingController(text: widget.team.contactEmail);
    _contactPhoneController = TextEditingController(text: widget.team.contactPhone);
    _selectedPlayerIds = List<String>.from(widget.team.players);
    _fetchPlayers();
  }

  void _fetchPlayers() async {
    final players = await FirestoreService().getPlayers().first;
    setState(() {
      _allPlayers = players;
    });
  }

  Future<void> _updateTeam() async {
    final updatedTeam = widget.team.copyWith(
      name: _teamNameController.text,
      coach: _coachNameController.text,
      players: _selectedPlayerIds,
      contactName: _contactNameController.text,
      contactEmail: _contactEmailController.text,
      contactPhone: _contactPhoneController.text,
    );
    await _firestoreService.createTeam(updatedTeam);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Edit Team'),
        backgroundColor: Color(0xFF002B7F),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Edit Team',
                style: TextStyle(
                  color: Color(0xFF002B7F),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  TextField(
                    controller: _contactNameController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Person Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contactEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contactPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone',
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
                    child: _allPlayers.isEmpty
                        ? const Text('No players available. Add players first in Player Management.')
                        : ListView(
                            children: _allPlayers.map((player) {
                              return CheckboxListTile(
                                value: _selectedPlayerIds.contains(player.id),
                                title: Text('${player.name} (Age: ${player.age}, Position: ${player.position})'),
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected == true) {
                                      _selectedPlayerIds.add(player.id);
                                    } else {
                                      _selectedPlayerIds.remove(player.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateTeam,
                    child: const Text('Update Team'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
