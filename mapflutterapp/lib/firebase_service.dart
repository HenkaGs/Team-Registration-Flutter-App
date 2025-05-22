import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'models/team.dart';
import 'models/player.dart';
import 'models/event.dart';

class AuthService {
  // Firebase authentication service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth change user stream
  Stream<User?> get user {
    return _auth.userChanges();
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Logout function
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error during logout: $e');
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new team
  Future<void> createTeam(Team team) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final teamWithUserId = team.copyWith(userId: user.uid);
        await _firestore.collection('teams').doc(team.id).set(teamWithUserId.toJson());
      }
    } catch (e) {
      log('Error creating team: $e');
    }
  }

  // Fetch all teams
  Stream<List<Team>> getTeams() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firestore
          .collection('teams')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Team.fromJson(doc.data())).toList();
      });
    } else {
      return const Stream.empty();
    }
  }

  // Update a team
  Future<void> updateTeam(Team team) async {
    try {
      await _firestore.collection('teams').doc(team.id).update(team.toJson());
    } catch (e) {
      log('Error updating team: $e');
    }
  }

  // Delete a team
  Future<void> deleteTeam(String teamId) async {
    try {
      await _firestore.collection('teams').doc(teamId).delete();
    } catch (e) {
      log('Error deleting team: $e');
    }
  }

  // PLAYER CRUD
  Future<void> createPlayer(Player player) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('players').doc(player.id).set(player.toJson());
      }
    } catch (e) {
      log('Error creating player: $e');
    }
  }

  Stream<List<Player>> getPlayers() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firestore
          .collection('players')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Player.fromJson(doc.data())).toList();
      });
    } else {
      return const Stream.empty();
    }
  }

  Future<void> updatePlayer(Player player) async {
    try {
      await _firestore.collection('players').doc(player.id).update(player.toJson());
    } catch (e) {
      log('Error updating player: $e');
    }
  }

  Future<void> deletePlayer(String playerId) async {
    try {
      await _firestore.collection('players').doc(playerId).delete();
    } catch (e) {
      log('Error deleting player: $e');
    }
  }

  // EVENT CRUD
  Future<void> createEvent(Event event) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('events').doc(event.id).set(event.toJson());
      }
    } catch (e) {
      log('Error creating event: $e');
    }
  }

  Stream<List<Event>> getEvents() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firestore
          .collection('events')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
      });
    } else {
      return const Stream.empty();
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toJson());
    } catch (e) {
      log('Error updating event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      log('Error deleting event: $e');
    }
  }
}