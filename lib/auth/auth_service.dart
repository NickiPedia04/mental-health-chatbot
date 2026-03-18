import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      // initiate google sign in pop up
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // req auth detail
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // create user's new credentials
      final OAuthCredential cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // sign in with google acc
      final UserCredential userCred = await _auth.signInWithCredential(cred);

      return userCred.user;
    } catch (e) {
      return null;
    }
  }
}
