import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginState with ChangeNotifier {
  CurrentUser? _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginState() {
    _checkCurrentUser();
  }

  CurrentUser? get currentUser => _currentUser;

  void _checkCurrentUser() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        _currentUser = null;
      } else {
        _currentUser = CurrentUser(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        );
      }
      notifyListeners();
    });
  }

  void setCurrentUser(GoogleSignInAccount? account) async {
    if (account == null) {
      _currentUser = null;
    } else {
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          _currentUser = CurrentUser(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            photoUrl: user.photoURL,
          );
          notifyListeners();
        }
      } catch (e) {
        print("Erro ao vincular a conta do Google ao usuário do Firebase: $e");
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      setCurrentUser(googleUser);
    } catch (e) {
      print("Erro ao fazer login com o Google: $e");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}

class CurrentUser {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  CurrentUser({this.uid, this.displayName, this.email, this.photoUrl});
}
