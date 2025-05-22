import 'package:flutter/material.dart';
import '../firebase_service.dart';
import '../models/team.dart';
import '../models/player.dart';
import '../models/event.dart';

class LiveUpdateItem {
  final String id;
  final String type; // 'team', 'player', 'event'
  final String title;
  final String description;
  final DateTime timestamp;

  LiveUpdateItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

class LiveUpdatesScreen extends StatelessWidget {
  const LiveUpdatesScreen({super.key});

  Stream<List<LiveUpdateItem>> _getLiveUpdates() async* {
    final firestoreService = FirestoreService();
    final teamStream = firestoreService.getTeams();
    final playerStream = firestoreService.getPlayers();
    final eventStream = firestoreService.getEvents();

    await for (final teams in teamStream) {
      final players = await playerStream.first;
      final events = await eventStream.first;
      final List<LiveUpdateItem> updates = [];
      for (final team in teams) {
        updates.add(LiveUpdateItem(
          id: team.id,
          type: 'team',
          title: 'Team: ${team.name}',
          description: 'Coach: ${team.coach}',
          timestamp: DateTime.fromMillisecondsSinceEpoch(int.tryParse(team.id) ?? 0),
        ));
      }
      for (final player in players) {
        updates.add(LiveUpdateItem(
          id: player.id,
          type: 'player',
          title: 'Player: ${player.name}',
          description: 'Position: ${player.position}, Age: ${player.age}',
          timestamp: DateTime.fromMillisecondsSinceEpoch(int.tryParse(player.id) ?? 0),
        ));
      }
      for (final event in events) {
        updates.add(LiveUpdateItem(
          id: event.id,
          type: 'event',
          title: 'Event: ${event.name}',
          description: 'Location: ${event.location}',
          timestamp: event.date,
        ));
      }
      updates.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      yield updates;
    }
  }

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
                      'Live Updates',
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
              child: StreamBuilder<List<LiveUpdateItem>>(
                stream: _getLiveUpdates(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final updates = snapshot.data ?? [];
                  if (updates.isEmpty) {
                    return const Center(child: Text('No updates yet.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: updates.length,
                    itemBuilder: (context, index) {
                      final item = updates[index];
                      IconData icon;
                      Color color;
                      switch (item.type) {
                        case 'team':
                          icon = Icons.group;
                          color = Colors.blue;
                          break;
                        case 'player':
                          icon = Icons.person;
                          color = Colors.green;
                          break;
                        case 'event':
                          icon = Icons.event;
                          color = Colors.orange;
                          break;
                        default:
                          icon = Icons.info;
                          color = Colors.grey;
                      }
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: Icon(icon, color: color, size: 32),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item.description),
                          trailing: Text(
                            '${item.timestamp.year}-${item.timestamp.month.toString().padLeft(2, '0')}-${item.timestamp.day.toString().padLeft(2, '0')}'
                            '\n${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          isThreeLine: true,
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
    );
  }
}
