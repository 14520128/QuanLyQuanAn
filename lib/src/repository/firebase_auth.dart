import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FireAuth _fireAuth = new FireAuth();

  static FireAuth get instance => _fireAuth;

  void dispose() {
    _fireAuth.dispose();
    print('FireAuth dispose');
  }

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
}
