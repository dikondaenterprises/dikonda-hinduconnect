import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Generic event logger
  static Future<void> logEvent(String eventName, Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid ?? 'anonymous';
    await _firestore.collection('analytics_events').add({
      'uid': uid,
      'event': eventName,
      'timestamp': FieldValue.serverTimestamp(),
      'data': data,
    });
  }

  /// Logs user search actions
  static Future<void> logSearch(String query, {required String type}) async {
    await logEvent('search', {'query': query, 'type': type});
  }

  /// Logs when a user views content
  static Future<void> logViewedContent(String fileName, {required String type}) async {
    await logEvent('view_content', {'file': fileName, 'type': type});
  }

  /// Logs bookmarking actions
  static Future<void> logBookmark(String fileName, {required bool added}) async {
    await logEvent('bookmark', {'file': fileName, 'action': added ? 'added' : 'removed'});
  }
}
