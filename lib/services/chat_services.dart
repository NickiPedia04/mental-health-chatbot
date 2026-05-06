import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  // create session
  Future<void> createSess(String sessName) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessName)
        .set({'createdAt': Timestamp.now()});
  }

  // send messages
  Future<void> sendMessages(
    String sessName,
    String text,
    bool isReceiver,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessName)
        .collection('messages')
        .add({
          'text': text,
          'isReceiver': isReceiver,
          'timestamp': Timestamp.now(),
        });
  }

  // load sessions
  Future<List<String>> loadSess() async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // load messages
  Future<List<Map<String, dynamic>>> loadMessages(String sessName) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('sessions')
        .doc(sessName)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        'text': data['text'],
        'isReceiver': data['isReceiver'],
        'time':
            '${(data['timestamp'] as Timestamp).toDate().hour.toString().padLeft(2, '0')}:${(data['timestamp'] as Timestamp).toDate().minute.toString().padLeft(2, '0')}',
      };
    }).toList();
  }
}
