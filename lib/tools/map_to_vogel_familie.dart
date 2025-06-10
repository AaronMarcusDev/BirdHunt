

import 'package:birdhunt/vogel_families/vogel_families.dart';

VogelFamilie vogelFamilieVanFirestoreMap(Map<String, dynamic> data) {
  return VogelFamilie(
    naam: data['naam'] ?? '',
    hex: data['hex'] ?? '',
  );
}

Map<String, String> vogelFamilieNaarFirestoreMap(VogelFamilie familie) {
  return {
    'naam': familie.naam,
    'hex': familie.hex,
  };
}