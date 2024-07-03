import 'package:flutter/material.dart';
import 'user_model.dart'; // Certifique-se de importar o UserModel corretamente

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void login(String displayName) {
    _user = UserModel(displayName: displayName);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;
}
