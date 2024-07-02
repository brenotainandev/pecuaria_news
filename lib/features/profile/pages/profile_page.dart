import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pecuaria_news/features/home/widgets/login_state.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        Provider.of<LoginState>(context, listen: false).setCurrentUser(account);
      });
    });
    _googleSignIn.signInSilently().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn().then((account) {
        Provider.of<LoginState>(context, listen: false).setCurrentUser(account);
      });
    } catch (error) {
      if (kDebugMode) {
        print('Erro no login do Google: $error');
      }
    }
  }

  Future<void> _handleGoogleSignOut() async {
    await _googleSignIn.disconnect().then((_) {
      Provider.of<LoginState>(context, listen: false).setCurrentUser(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o estado do login atual através do Provider
    final currentUser = Provider.of<LoginState>(context).currentUser;

    Widget loginSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Bem-vindo!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24.0),
        ElevatedButton.icon(
          onPressed: _handleGoogleSignIn,
          label: const Text('Entrar com o Google'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.brown,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ],
    );

    Widget profileSection = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Olá, ${currentUser?.displayName ?? 'Usuário'}!',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24.0),
        ElevatedButton.icon(
          onPressed: _handleGoogleSignOut,
          icon: const Icon(Icons.exit_to_app),
          label: const Text('Sair'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.brown,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ],
    );

    // Aqui você deve ajustar a lógica para verificar se o usuário está logado
    // Isso pode depender de como você implementou o estado do login no seu Provider
    bool isUserLoggedIn = currentUser != null;

    Widget content = !isUserLoggedIn ? loginSection : profileSection;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFC2B280),
              Color(0xFFA5E79C),
              Color(0xFFD7FFFF),
            ],
          ),
        ),
        child: Center(
          child: content,
        ),
      ),
    );
  }
}
