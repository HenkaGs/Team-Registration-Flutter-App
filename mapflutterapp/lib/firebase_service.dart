import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/team.dart';

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
      print(e);
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
      print(e);
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
      print('Error during logout: $e');
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
      print('Error creating team: $e');
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
      print('Error updating team: $e');
    }
  }

  // Delete a team
  Future<void> deleteTeam(String teamId) async {
    try {
      await _firestore.collection('teams').doc(teamId).delete();
    } catch (e) {
      print('Error deleting team: $e');
    }
  }
}