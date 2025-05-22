import 'package:flutter/material.dart';
import '../models/event.dart';
import '../firebase_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _location = '';
  DateTime? _date;
  String? _editingId;

  @override
  Widget build(BuildContext context) {
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
                      'Events',
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
            Expanded(
              child: StreamBuilder<List<Event>>(
                stream: _firestoreService.getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final events = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        title: Text(event.name),
                        subtitle: Text('Date: ${event.date.toLocal().toString().split(' ')[0]}\nLocation: ${event.location}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEventDialog(event: event),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _firestoreService.deleteEvent(event.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () => _showEventDialog(),
              backgroundColor: const Color(0xFF002B7F),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEventDialog({Event? event}) {
    if (event != null) {
      _name = event.name;
      _location = event.location;
      _date = event.date;
      _editingId = event.id;
    } else {
      _name = '';
      _location = '';
      _date = null;
      _editingId = null;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event == null ? 'Add Event' : 'Edit Event'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter event name' : null,
                onChanged: (value) => _name = value,
              ),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value == null || value.isEmpty ? 'Enter location' : null,
                onChanged: (value) => _location = value,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(_date == null
                        ? 'No date selected'
                        : 'Date: ${_date!.toLocal().toString().split(' ')[0]}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _date = picked;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
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
              if (_formKey.currentState!.validate() && _date != null) {
                if (_editingId != null) {
                  await _firestoreService.updateEvent(Event(id: _editingId!, name: _name, date: _date!, location: _location));
                } else {
                  final newId = DateTime.now().millisecondsSinceEpoch.toString();
                  await _firestoreService.createEvent(Event(id: newId, name: _name, date: _date!, location: _location));
                }
                Navigator.pop(context);
              }
            },
            child: Text(event == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
