import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class noteService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  // list available notes
  Stream<QuerySnapshot> getNote() {
    return _db
        .collection('notes')
        .where('uid', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // add notes
  Future<String> addNote(String header, String content) async {
    final docRef = await _db.collection('notes').add({
      'uid': userId,
      'header': header,
      'content': content,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });

    return docRef.id;
  }

  // update notes
  Future<void> updateNote(String docId, String header, String content) async {
    await _db.collection('notes').doc(docId).update({
      'header': header,
      'content': content,
      'updatedAt': Timestamp.now(),
    });
  }

  // delete notes
  Future<void> deleteNote(String docId) async {
    await _db.collection('notes').doc(docId).delete();
  }
}
