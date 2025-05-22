import 'package:flutter/material.dart';
import '../models/player.dart';
import '../firebase_service.dart';

class PlayerManagementScreen extends StatefulWidget {
  const PlayerManagementScreen({super.key});

  @override
  State<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends State<PlayerManagementScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _position = '';
  int? _age;
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    const deepBlue = Color(0xFF002B7F);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue header with curved bottom edges and back arrow
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF002B7F),
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
                      'Players',
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
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Player>>(
                stream: _firestoreService.getPlayers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final players = snapshot.data ?? [];
                  if (players.isEmpty) {
                    return const Center(child: Text('No players registered yet.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: deepBlue,
                            child: Text(player.name.isNotEmpty ? player.name[0] : '?', style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Position: ${player.position}\nAge: ${player.age}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showPlayerDialog(player: player),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _firestoreService.deletePlayer(player.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPlayerDialog(),
        backgroundColor: deepBlue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPlayerDialog({Player? player}) {
    if (player != null) {
      _name = player.name;
      _position = player.position;
      _age = player.age;
      _editingId = player.id;
    } else {
      _name = '';
      _position = '';
      _age = null;
      _editingId = null;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(player == null ? 'Add Player' : 'Edit Player'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter name' : null,
                onChanged: (value) => _name = value,
              ),
              TextFormField(
                initialValue: _position,
                decoration: const InputDecoration(labelText: 'Position'),
                validator: (value) => value == null || value.isEmpty ? 'Enter position' : null,
                onChanged: (value) => _position = value,
              ),
              TextFormField(
                initialValue: _age?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter age' : null,
                onChanged: (value) => _age = int.tryParse(value),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (_editingId != null) {
                  await _firestoreService.updatePlayer(Player(id: _editingId!, name: _name, age: _age!, position: _position));
                } else {
                  final newId = DateTime.now().millisecondsSinceEpoch.toString();
                  await _firestoreService.createPlayer(Player(id: newId, name: _name, age: _age!, position: _position));
                }
                Navigator.pop(context);
              }
            },
            child: Text(player == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
