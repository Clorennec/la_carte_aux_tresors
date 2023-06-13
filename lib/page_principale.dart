// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:la_carte_aux_tresors/gestion_donnees.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  final List<Marker> _marqueurs = [];

  void _ajouterMarqueur(LatLng position, String id, String titre) {
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
      position: position,
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
        body: GoogleMap(
          initialCameraPosition: position,
          markers: Set.of(_marqueurs),
        ));
  }

  Future<LatLng> _lirePositionActuelle() async {
    Location localisation = Location();
    bool serviceActif;
    PermissionStatus autorisationAccordee;
    LocationData donneesLocalisation;
    serviceActif = await localisation.serviceEnabled();
    if (serviceActif) {
      serviceActif = await localisation.requestService();
      if (!serviceActif) {
        return position.target;
      }
      autorisationAccordee = await localisation.hasPermission();
      if (autorisationAccordee == PermissionStatus.denied) {
        autorisationAccordee = await localisation.requestPermission();
        if (autorisationAccordee != PermissionStatus.granted) {
          return position.target;
        }
      }
      donneesLocalisation = await localisation.getLocation();
      return (LatLng(donneesLocalisation.latitude ?? position.target.latitude,
          donneesLocalisation.longitude ?? position.target.longitude));
    } else {
      return position.target;
    }
  }

  @override
  void initState() {
    super.initState();
    chargerLieuxDansFirebase();
    _lirePositionActuelle().then((position) {
      final LatLng positionActuelle =
          LatLng(position.latitude, position.longitude);
      print(positionActuelle);
      _ajouterMarqueur(
          positionActuelle, 'positionCourante', 'Position Actuelle');
    }).catchError((error) {
      print('Erreur lors de la récupération de la position actuelle: $error');
    });
    print(position.target.toString());
  }
}
