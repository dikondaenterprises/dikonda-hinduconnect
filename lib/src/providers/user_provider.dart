import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  String? uid;
  String preferredLanguage = 'english';
  List<String> bookmarks = [];

  /// Call after login to load user data
  Future<void> loadUser(String userId) async {
    uid = userId;
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data()!;
      preferredLanguage = data['stotraLanguage'] as String? ?? 'english';
      bookmarks = List<String>.from(data['bookmarks'] ?? []);
    } else {
      // initialize if new
      await _firestore.collection('users').doc(userId).set({
        'stotraLanguage': preferredLanguage,
        'bookmarks': bookmarks,
      });
    }
    notifyListeners();
  }

  Future<void> updatePreferredLanguage(String lang) async {
    if (uid == null) return;
    preferredLanguage = lang;
    await _firestore.collection('users').doc(uid).update({'stotraLanguage': lang});
    notifyListeners();
  }

  Future<void> addBookmark(String id) async {
    if (uid == null) return;
    if (!bookmarks.contains(id)) {
      bookmarks.add(id);
      await _firestore.collection('users').doc(uid).update({'bookmarks': bookmarks});
      notifyListeners();
    }
  }

  Future<void> removeBookmark(String id) async {
    if (uid == null) return;
    if (bookmarks.remove(id)) {
      await _firestore.collection('users').doc(uid).update({'bookmarks': bookmarks});
      notifyListeners();
    }
  }

  bool isBookmarked(String id) => bookmarks.contains(id);
}
