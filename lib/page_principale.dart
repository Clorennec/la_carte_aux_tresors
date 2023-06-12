import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  List<Marker> _marqueurs = [];

  void ajouterMarqueur(LatLng position, String id, String titre) {
    Marker marqueurTemp =
        Marker(markerId: MarkerId(id), infoWindow: InfoWindow(title: titre));
    _marqueurs.add(marqueurTemp);
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
        body: const GoogleMap(initialCameraPosition: position));
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

    @override
    void initState() {
      super.initState();
      LatLng enplacement = _lirePositionActuelle() as LatLng;
    }
  }
}
