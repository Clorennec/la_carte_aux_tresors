import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
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
}
