// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:la_carte_aux_tresors/utilitaires/gestion_donnees.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';

import 'dialogue_lieu.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  final List<Marker> _marqueurs = [];
  List<Lieu> lieux = [];

  void _ajouterMarqueur(Position position, String id, String titre) {
    BitmapDescriptor marqueurIcon;
    if (id == 'positionCourante') {
      // Marqueur pour la position actuelle
      marqueurIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    } else {
      // Autres marqueurs
      marqueurIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
    final infoWindow = InfoWindow(title: titre);
    final marqueur = Marker(
      markerId: MarkerId(id),
      position: LatLng(position.latitude, position.longitude),
      icon: marqueurIcon,
      infoWindow: infoWindow,
    );
    setState(() {
      _marqueurs.add(marqueur);
    });
  }

  static const CameraPosition position = CameraPosition(
    target: LatLng(50.611256, 3.134842),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte aux trésors'),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: chargerDonneesDepuisFirebase('utilisateur1'),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // En cours de chargement des données
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Erreur lors du chargement des données
              return const Center(
                  child: Text('Erreur de chargement des données'));
            } else {
              // Données chargées avec succès
              List<Lieu> lieux = snapshot.data!.docs
                  .map((doc) =>
                      Lieu.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                  .toList();
              _marqueurs.addAll(lieux.map((lieu) {
                return Marker(
                  markerId: MarkerId(lieu.idLieu),
                  position: LatLng(lieu.latitude, lieu.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange),
                  infoWindow: InfoWindow(title: lieu.designation),
                );
              }));
            }

            return GoogleMap(
              initialCameraPosition: position,
              markers: Set.of(_marqueurs),
              mapType: MapType.normal,
              myLocationEnabled: true,
            );
          }),
      floatingActionButton: Stack(
        children: [
          Positioned(
              left: 40,
              bottom: 40,
              child: FloatingActionButton(
                onPressed: () async {
                  Marker? currentPositionMarker = _marqueurs.firstWhere(
                      (marker) => marker.markerId.value == 'positionCourante');
                  LatLng currentLatLng = currentPositionMarker.position;
                  Lieu lieu = Lieu(
                      designation: '',
                      latitude: currentLatLng.latitude,
                      longitude: currentLatLng.longitude,
                      date: DateTime.now(),
                      idLieu: '',
                      idUtilisateur: '');
                  DialogueLieu dialogueLieu =
                      DialogueLieu(estNouveau: true, lieu: lieu);
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        dialogueLieu.build(context),
                  );
                },
              ))
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  initState() {
    super.initState();

    chargerLieuxDansFirebase().then((_) {
      // Données insérées avec succès, vous pouvez effectuer d'autres opérations ici si nécessaire
    }).catchError((error) {
      print('''Erreur lors de l'insertion des lieux : $error''');
    });
    _determinePosition().then((pos) {
      print(
          '===========================> lat ${pos.latitude} / lon ${pos.longitude}');
      _ajouterMarqueur(pos, 'positionCourante', 'Vous êtes içi');
    }).catchError((error) {
      print('Erreur lors de la récupération de la position actuelle: $error');
    });

    chargerDonneesDepuisFirebase('utilisateur1').then((snapshot) {
      setState(() {
        lieux = extraireLieux(snapshot);
      });
    }).catchError((error) {
      print('Erreur lors de la récupération des lieux : $error');
    });
  }

  List<Lieu> extraireLieux(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Lieu.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
