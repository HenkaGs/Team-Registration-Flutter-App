import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_service.dart';
import '../models/team.dart';
import '../models/player.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _coachNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<Player> _allPlayers = [];
  List<String> _selectedPlayerIds = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  void _fetchPlayers() async {
    final players = await FirestoreService().getPlayers().first;
    setState(() {
      _allPlayers = players;
    });
  }

  Future<void> _createTeam() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in.')),
        );
      }
      return;
    }

    final newTeam = Team(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _teamNameController.text,
      coach: _coachNameController.text,
      players: _selectedPlayerIds,
      userId: userId,
      contactName: _contactNameController.text,
      contactEmail: _contactEmailController.text,
      contactPhone: _contactPhoneController.text,
    );
    await _firestoreService.createTeam(newTeam);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const deepBlue = Color(0xFF002B7F);
    const flagRed = Color(0xFFC8102E);
    const flagGreen = Color(0xFF007A33);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with Back Button
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: deepBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Create Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildField(_teamNameController, 'Team Name'),
                    const SizedBox(height: 16),
                    _buildField(_coachNameController, 'Coach Name'),
                    const SizedBox(height: 16),
                    _buildField(_contactNameController, 'Contact Person Name'),
                    const SizedBox(height: 16),
                    _buildField(_contactEmailController, 'Contact Email'),
                    const SizedBox(height: 16),
                    _buildField(_contactPhoneController, 'Contact Phone'),
                    const SizedBox(height: 24),

                    const Text(
                      'Players:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Player selection (multi-select)
                    _allPlayers.isEmpty
                        ? const Text('No players available. Add players first in Player Management.')
                        : Column(
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
                    const SizedBox(height: 8),

                    // Create Team Button
                    _buildActionButton(
                      text: 'Create Team',
                      color: flagRed,
                      onTap: _createTeam,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
