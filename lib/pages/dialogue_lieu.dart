import 'package:flutter/material.dart';
import 'package:la_carte_aux_tresors/modeles/lieu.dart';
import 'package:la_carte_aux_tresors/utilitaires/gestion_donnees.dart';

class DialogueLieu extends StatelessWidget {
  final GestionBdD bdd = GestionBdD();

  final TextEditingController txtDes = TextEditingController();
  final TextEditingController txtAdresse = TextEditingController();
  final TextEditingController txtLat = TextEditingController();
  final TextEditingController txtLon = TextEditingController();

  final bool estNouveau;
  final Lieu lieu;

  DialogueLieu({required this.estNouveau, required this.lieu}) {
    txtDes.text = lieu.designation;
    txtLat.text = lieu.latitude.toString();
    txtLon.text = lieu.longitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Endroit'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: txtDes,
                decoration: const InputDecoration(hintText: 'Désignation'),
              ),
              TextField(
                controller: txtLat,
                decoration: const InputDecoration(hintText: 'Latitude'),
              ),
              TextField(
                controller: txtLon,
                decoration: const InputDecoration(hintText: 'Longitude'),
              ),
              ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    lieu.designation = txtDes.text;
                    lieu.latitude = double.parse(txtLat.text);
                    lieu.longitude = double.parse(txtLon.text);
                    if (estNouveau) {
                      bdd.ajouterLieu(lieu.toMap());
                    } else {
                      bdd.modifierLieu(lieu.idLieu, lieu.toMap());
                    }
                    Navigator.pop(context);
                  })
            ],
          ),
        ));
  }
}
