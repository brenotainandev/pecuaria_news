import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pecuaria_news/features/home/widgets/login_state.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // Substitua pelo caminho correto da sua classe LoginState
import 'app.dart'; // Substitua pelo caminho correto do seu widget App

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: const App(),
    ),
  );
}
