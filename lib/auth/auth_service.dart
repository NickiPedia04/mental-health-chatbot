import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user
  User? getCurrUser() {
    return _auth.currentUser;
  }

  // sign in
  Future<UserCredential> signInEmailPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register
  Future<UserCredential> signUpUsernameEmailPassword(
    String username,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await addUserDetails(username, email);

      print('user details contains: $username and $email');

      return userCred;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // google sign in
  Future<User?> signInGoogle() async {
    try {
      print('Initializing Google Sign In');

      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId:
            '644908706342-vv58e9rtakubkhomj9nr6elqqfclvuvf.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final googleCred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(googleCred);

      await addUserDetails(
        userCred.user!.displayName ?? 'No Name',
        userCred.user!.email ?? '',
      );

      print('Success: $userCred');

      return userCred.user;
    } catch (e) {
      print("Erorr: $e");
      return null;
    }
  }

  // add user's detail to firestore
  Future<void> addUserDetails(String username, String email) async {
    final user = _auth.currentUser;

    print(user?.uid);

    if (user == null) return;

    final db = FirebaseFirestore.instance
        .collection('user-details')
        .doc(user.uid);

    final snapshot = await db.get();

    if (!snapshot.exists) {
      await db.set({"email": email, "username": username});
      print('user saved to firestore');
    }
  }
}
