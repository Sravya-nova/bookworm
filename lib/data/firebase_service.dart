import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/author_models.dart';
import '../models/stats_models.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Authentication ---

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      await _initializeNewUser(credential.user!.uid, email);
    }
    return credential;
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      await _initializeNewUser(credential.user!.uid, email);
    }
    return credential;
  }

  Future<UserCredential> signInAnonymously() async {
    final credential = await _auth.signInAnonymously();
    if (credential.user != null) {
      await _initializeNewUser(credential.user!.uid, 'Anonymous User');
    }
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _initializeNewUser(String uid, String name) async {
    final profileDoc = await _db.collection('users').doc(uid).get();
    if (!profileDoc.exists) {
      await _db.collection('users').doc(uid).set({
        'name': name.contains('@') ? name.split('@')[0] : name,
        'bio': 'New bibliophile in the Sanctuary.',
        'avatarUrl': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
        'role': 'Reader',
        'publishedWorks': 0,
        'followers': 0,
        'genres': [],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _db.collection('stats').doc(uid).set({
        'currentStreak': 0,
        'pagesRead': 0,
        'hoursListened': 0.0,
        'booksFinished': 0,
        'totalGoal': 10,
        'reviewStreak': 0,
        'genreBreakdown': {},
      }, SetOptions(merge: true));
    }
  }

  // --- Profile Maintenance ---

  Future<void> updateProfile(AuthorProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).set({
      'name': profile.name,
      'bio': profile.bio,
      'avatarUrl': profile.avatarUrl,
      'role': profile.role,
      'publishedWorks': profile.publishedWorks,
      'followers': profile.followers,
      'genres': profile.genres,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> incrementPublishedWorks() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).set({
      'publishedWorks': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<AuthorProfile?> fetchProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      await _initializeNewUser(user.uid, user.email ?? 'User');
      return fetchProfile();
    }

    final data = doc.data()!;
    data['id'] = doc.id;
    return AuthorProfile.fromJson(data);
  }

  // --- Streak & Stats Maintenance ---

  Future<void> incrementStreak() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('stats').doc(user.uid).set({
      'currentStreak': FieldValue.increment(1),
      'lastReadAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addPagesRead(int count) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('stats').doc(user.uid).set({
      'pagesRead': FieldValue.increment(count),
    }, SetOptions(merge: true));
  }

  Future<void> finishBook() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('stats').doc(user.uid).set({
      'booksFinished': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<ReadingStats?> fetchReadingStats() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('stats').doc(user.uid).get();
    if (!doc.exists) {
      await _initializeNewUser(user.uid, user.email ?? 'User');
      return fetchReadingStats();
    }

    return ReadingStats.fromJson(doc.data()!);
  }

  // --- Writing (Drafts) ---

  Future<String> saveDraft({String? id, required String title, required String content, double progress = 0.0}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final draftData = {
      'title': title,
      'content': content,
      'lastEdited': DateTime.now().toIso8601String(),
      'completionPercentage': progress,
      'userId': user.uid,
    };

    if (id != null) {
      await _db.collection('drafts').doc(id).set(draftData, SetOptions(merge: true));
      return id;
    } else {
      final docRef = await _db.collection('drafts').add(draftData);
      return docRef.id;
    }
  }

  Future<List<Draft>> fetchDrafts() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    // Removed orderBy to avoid index requirement for first-time use
    final snapshot = await _db.collection('drafts')
        .where('userId', isEqualTo: user.uid)
        .get();

    final drafts = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Draft.fromJson(data);
    }).toList();

    // Sort in memory instead
    drafts.sort((a, b) => b.lastEdited.compareTo(a.lastEdited));
    return drafts;
  }
}
