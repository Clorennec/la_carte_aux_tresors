// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';

class GestionBdD {
  static CollectionReference<Map<String, dynamic>> lieuxCollection =
      FirebaseFirestore.instance.collection('lieux');

  static Future<void> ajouterLieu(Map<String, dynamic> lieuData) async {
    await lieuxCollection.add(lieuData);
  }

  static Future<void> modifierLieu(
      String idLieu, Map<String, dynamic> lieuData) async {
    await lieuxCollection.doc(idLieu).update(lieuData);
  }

  static Future<void> supprimerLieu(String idLieu) async {
    await lieuxCollection.doc(idLieu).delete();
  }

  static Future<int> longueurBdD(idUtilisateur) async {
    final querySnapshot = await lieuxCollection
        .where('idUtilisateur', isEqualTo: idUtilisateur)
        .get();
    return querySnapshot.size;
  }
}

Future<QuerySnapshot> chargerDonneesDepuisFirebase(String idUtilisateur) async {
  CollectionReference lieuxCollection =
      FirebaseFirestore.instance.collection('lieux');
  QuerySnapshot snapshot = await lieuxCollection
      .where('idUtilisateur', isEqualTo: idUtilisateur)
      .get();
  return snapshot;
}

Future<void> chargerLieuxDansFirebase() async {
  List<Lieu> lieux = [];

  for (Lieu lieu in lieux) {
    await FirebaseFirestore.instance.collection('lieux').add(lieu.toMap());
  }

  print('Lieux insérés dans la base de données :');
  lieux.forEach((lieu) {
    print(lieu.toString());
  });

  Future<void> ajouterLieu(Lieu lieu) async {
    try {
      await FirebaseFirestore.instance.collection('lieux').add(lieu.toMap());
      await chargerLieuxDansFirebase();
      print('Nouveau lieu ajouté : $lieu');
    } catch (error) {
      print('''Erreur lors de l'ajout du lieu : $error''');
    }
  }

  Future<void> supprimerLieu(String idLieu) async {
    try {
      await FirebaseFirestore.instance.collection('lieux').doc(idLieu).delete();
      print('Lieu supprimé avec succès : $idLieu');
    } catch (error) {
      print('Erreur lors de la suppression du lieu : $error');
    }
  }
}
