import 'package:flutter/material.dart';
import 'package:la_carte_aux_tresors/page_principale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PagePrincipale());
  }
}
