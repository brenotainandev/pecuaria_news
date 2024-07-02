import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  // Supondo que a classe CurrentUser já esteja definida em algum lugar
  CurrentUser? _currentUser;

  // Método ajustado para aceitar GoogleSignInAccount
  void setCurrentUser(GoogleSignInAccount? account) async {
    if (account == null) {
      _currentUser = null;
    } else {
      // Aqui você precisa converter GoogleSignInAccount para um User do Firebase
      // Isso é um exemplo genérico. Você precisará ajustar de acordo com sua lógica de autenticação
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      _currentUser = CurrentUser(
        userId: firebaseUser?.uid,
        userName: firebaseUser?.displayName,
        // Adicione outras propriedades conforme necessário
      );
    }
    notifyListeners();
  }

  // Getter para currentUser
  CurrentUser? get currentUser => _currentUser;
}

class CurrentUser {
  final String? userId;
  final String? userName;
  // Adicione outras propriedades conforme necessário

  CurrentUser({this.userId, this.userName});

  // Getter para displayName
  String? get displayName => userName;
}
