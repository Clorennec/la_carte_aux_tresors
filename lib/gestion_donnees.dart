// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la_carte_aux_tresors/lieu.dart';

Future<QuerySnapshot> chargerDonneesDepuisFirebase(String idUtilisateur) async {
  CollectionReference lieuxCollection =
      FirebaseFirestore.instance.collection('lieux');
  QuerySnapshot snapshot = await lieuxCollection
      .where('idUtilisateur', isEqualTo: idUtilisateur)
      .get();
  return snapshot;
}

Future<void> chargerLieuxDansFirebase() async {
  List<Lieu> lieux = [
    Lieu(
      idLieu: '1',
      idUtilisateur: 'utilisateur1',
      designation: 'Tour Eiffel',
      latitude: 48.8584,
      longitude: 2.2945,
      photo: 'https://example.com/tour_eiffel.jpg',
      adresse: 'Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France',
      date: DateTime.now(),
    ),
    Lieu(
      idLieu: '2',
      idUtilisateur: 'utilisateur1',
      designation: 'Statue de la Liberté',
      latitude: 40.6892,
      longitude: -74.0445,
      photo: 'https://example.com/statue_liberte.jpg',
      adresse: 'Liberty Island, New York, NY 10004, États-Unis',
      date: DateTime.now(),
    ),
    Lieu(
      idLieu: '3',
      idUtilisateur: 'utilisateur1',
      designation: 'Pyramide de Khéops',
      latitude: 29.9792,
      longitude: 31.1342,
      photo: 'https://example.com/pyramide_kheops.jpg',
      adresse: 'Al Haram, Nazlet El-Semman, Al Giza Desert, Gizeh, Égypte',
      date: DateTime.now(),
    ),
    Lieu(
      idLieu: '4',
      idUtilisateur: 'utilisateur1',
      designation: 'Machu Picchu',
      latitude: -13.1631,
      longitude: -72.5450,
      photo: 'https://example.com/machu_picchu.jpg',
      adresse: 'Aguas Calientes, 08680, Pérou',
      date: DateTime.now(),
    ),
    Lieu(
      idLieu: '5',
      idUtilisateur: 'utilisateur1',
      designation: 'Colisée de Rome',
      latitude: 41.8902,
      longitude: 12.4922,
      photo: 'https://example.com/colisee_rome.jpg',
      adresse: 'Piazza del Colosseo, 1, 00184 Roma RM, Italie',
      date: DateTime.now(),
    ),
    Lieu(
      idLieu: '6',
      idUtilisateur: 'utilisateur1',
      designation: 'Grande Muraille de Chine',
      latitude: 40.4319,
      longitude: 116.5704,
      photo: 'https://example.com/grande_muraille_chine.jpg',
      adresse: 'Huairou, Pékin, Chine',
      date: DateTime.now(),
    )
  ];

  for (Lieu lieu in lieux) {
    await FirebaseFirestore.instance.collection('lieux').add(lieu.toMap());
  }

  print('Lieux insérés dans la base de données :');
  lieux.forEach((lieu) {
    print(lieu.toString());
  });
}
