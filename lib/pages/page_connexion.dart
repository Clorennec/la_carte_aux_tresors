import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_carte_aux_tresors/pages/page_principale.dart';

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
        MaterialPageRoute(builder: (context) => PagePrincipale()),
      );
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur de connexion : $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _connexionUtilisateur,
              child: Text('Se connecter'),
            ),
            SizedBox(height: 8.0),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
