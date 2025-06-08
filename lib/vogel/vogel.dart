class Vogel {
  final String naam;
  final String latijnseNaam;
  final String familie;
  final String familieKleur;
  final String beschrijving;
  final String hoofdFotoUrl;
  final String lijstFotoUrl;
  final String wikipediaUrl;
  final String vogelbeschermingUrl;
  final Map<String, FotoInfo> fotosPerGebruiker;

  Vogel({
    required this.naam,
    required this.latijnseNaam,
    required this.familie,
    required this.familieKleur,
    required this.beschrijving,
    required this.hoofdFotoUrl,
    required this.lijstFotoUrl,
    required this.wikipediaUrl,
    required this.vogelbeschermingUrl,
    required this.fotosPerGebruiker,
  });

  // Converteer Vogel naar Map voor Firestore
  Map<String, dynamic> toMap() {
    return {
      'naam': naam,
      'latijnseNaam': latijnseNaam,
      'familie': familie,
      'familieKleur': familieKleur,
      'beschrijving': beschrijving,
      'hoofdFotoUrl': hoofdFotoUrl,
      'lijstFotoUrl': lijstFotoUrl,
      'wikipediaUrl': wikipediaUrl,
      'vogelbeschermingUrl': vogelbeschermingUrl,
      'fotosPerGebruiker': fotosPerGebruiker.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  // Maak Vogel van Firestore document
  factory Vogel.fromMap(Map<String, dynamic> map) {
    return Vogel(
      naam: map['naam'] ?? '',
      latijnseNaam: map['latijnseNaam'] ?? '',
      familie: map['familie'] ?? '',
      familieKleur: map['familieKleur'] ?? '',
      beschrijving: map['beschrijving'] ?? '',
      hoofdFotoUrl: map['hoofdFotoUrl'] ?? '',
      lijstFotoUrl: map['lijstFotoUrl'] ?? '',
      wikipediaUrl: map['wikipediaUrl'] ?? '',
      vogelbeschermingUrl: map['vogelbeschermingUrl'] ?? '',
      fotosPerGebruiker: (map['fotosPerGebruiker'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, FotoInfo.fromMap(value))),
    );
  }
}

class FotoInfo {
  final String fotoUrl;
  final String locatie;

  FotoInfo({
    required this.fotoUrl,
    required this.locatie,
  });

  Map<String, dynamic> toMap() {
    return {
      'fotoUrl': fotoUrl,
      'locatie': locatie,
    };
  }

  factory FotoInfo.fromMap(Map<String, dynamic> map) {
    return FotoInfo(
      fotoUrl: map['fotoUrl'] ?? '',
      locatie: map['locatie'] ?? '',
    );
  }
}