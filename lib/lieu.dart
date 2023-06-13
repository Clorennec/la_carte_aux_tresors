class Lieu {
  final String idLieu;
  final String idUtilisateur;
  final String designation;
  final double latitude;
  final double longitude;
  String photo;
  String adresse;
  DateTime date;

  Lieu({
    required this.idLieu,
    required this.idUtilisateur,
    required this.designation,
    required this.latitude,
    required this.longitude,
    this.photo = '',
    this.adresse = '',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'idLieu': idLieu,
      'idUtilisateur': idUtilisateur,
      'designation': designation,
      'latitude': latitude,
      'longitude': longitude,
      'photo': photo,
      'adresse': adresse,
      'date': date.toIso8601String(),
    };
  }

  static Lieu fromMap(String idLieu, Map<String, dynamic> map) {
    return Lieu(
      idLieu: idLieu,
      idUtilisateur: map['idUtilisateur'],
      designation: map['designation'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      photo: map['photo'],
      adresse: map['adresse'],
      date: DateTime.parse(map['date']),
    );
  }
}
