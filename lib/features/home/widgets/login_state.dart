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

  // Verifica o estado atual do usuário no FirebaseAuth
  void _checkCurrentUser() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _updateCurrentUser(user);
    });
  }

  // Atualiza o _currentUser com base no User do FirebaseAuth
  void _updateCurrentUser(User? user) {
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
  }

  // Define o usuário atual com base na conta do GoogleSignIn
  void setCurrentUser(GoogleSignInAccount? account) async {
    if (account == null) {
      _currentUser = null;
      notifyListeners();
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
        _updateCurrentUser(userCredential.user);
      } catch (e) {
        print("Erro ao vincular a conta do Google ao usuário do Firebase: $e");
        // Considerar notificar os ouvintes mesmo em caso de erro para refletir qualquer mudança de estado
        notifyListeners();
      }
    }
  }

  // Inicia o processo de login com o Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      setCurrentUser(googleUser);
    } catch (e) {
      print("Erro ao fazer login com o Google: $e");
      notifyListeners(); // Notificar em caso de falha para permitir que a UI reaja adequadamente
    }
  }

  // Realiza o logout do usuário
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print("Erro ao tentar sair: $e");
      // Mesmo em caso de erro, considerar a necessidade de atualizar a UI
      notifyListeners();
    }
  }
}

class CurrentUser {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  CurrentUser({this.uid, this.displayName, this.email, this.photoUrl});
}
