import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_carte_aux_tresors/pages/page_principale.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PageConnexion extends StatefulWidget {
  @override
  _PageConnexionState createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  Future<void> _connexionUtilisateur() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      // Connexion à l'aide de l'e-mail et du mot de passe
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Connexion réussie, rediriger vers la page principale
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PagePrincipale()),
      );
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur de connexion : $error';
      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      // Demander à l'utilisateur de choisir son compte Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // Obtenir les informations d'authentification de Google
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Créer les informations de connexion avec Google
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Authentifier l'utilisateur avec Firebase
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential;
      }
    } catch (e) {
      print('Erreur lors de la connexion avec Google : $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _connexionUtilisateur,
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 8.0),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            ElevatedButton(
                onPressed: signInWithGoogle, child: const Text("Google"))
          ],
        ),
      ),
    );
  }
}
