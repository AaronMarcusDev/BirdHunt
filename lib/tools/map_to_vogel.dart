import 'package:birdhunt/vogel/vogel.dart';

Vogel vogelVanFirestoreMap(Map<String, dynamic> data) {
  return Vogel(
    naam: data['naam'] ?? '',
    latijnseNaam: data['latijnseNaam'] ?? '',
    familie: data['familie'] ?? '',
    familieKleur: data['familieKleur'] ?? '#000000',
    beschrijving: data['beschrijving'] ?? '',
    hoofdFotoUrl: data['hoofdFotoUrl'] ?? '', // zelfde als lijstFoto
    lijstFotoUrl: data['lijstFotoUrl'] ?? '',
    wikipediaUrl: data['wikipediaUrl'] ?? '',
    vogelbeschermingUrl: data['vogelbeschermingUrl'] ?? '',
    fotosPerGebruiker: {
      'Kristiaan': FotoInfo(
        fotoUrl: data['fotoKristiaanUrl'] ?? '',
        locatie: data['fotoKristiaanLocatie'] ?? '',
      ),
      'Aaron': FotoInfo(
        fotoUrl: data['fotoAaronUrl'] ?? '',
        locatie: data['fotoAaronLocatie'] ?? '',
      ),
    },
  );
}

Map<String, dynamic> vogelNaarFirestoreMap(Vogel vogel) {
  return {
    'naam': vogel.naam,
    'latijnseNaam': vogel.latijnseNaam,
    'familie': vogel.familie,
    'familieKleur': vogel.familieKleur,
    'beschrijving': vogel.beschrijving,
    'hoofdFotoUrl': vogel.hoofdFotoUrl,
    'lijstFotoUrl': vogel.lijstFotoUrl,
    'wikipediaUrl': vogel.wikipediaUrl,
    'vogelbeschermingUrl': vogel.vogelbeschermingUrl,
    'fotoKristiaanUrl': vogel.fotosPerGebruiker['Kristiaan']?.fotoUrl ?? '',
    'fotoKristiaanLocatie': vogel.fotosPerGebruiker['Kristiaan']?.locatie ?? '',
    'fotoAaronUrl': vogel.fotosPerGebruiker['Aaron']?.fotoUrl ?? '',
    'fotoAaronLocatie': vogel.fotosPerGebruiker['Aaron']?.locatie ?? '',
  };
}


// String testvogel() {
//   return vogelVanFirestoreMap({
//       'naam':'Roodborst',
//       'latijnseNaam':'Erithacus rubecula',
//       'familie':'Muscicapidea (vliegenvangers)',
//       'familiekleur':'#6556BF',
//       'beschrijving':'Een kleine zangvogel die makkelijk te herkennen is aan zijn oranje borst en gezicht. Hij komt veel voor in tuinen, bossen en parken.',
//       'hoofdFotoUrl':'https://www.rootsmagazine.nl/app/uploads/sites/5/2022/02/roodborst-24-scaled.jpg',
//       'lijstFotoUrl': 'https://www.rootsmagazine.nl/app/uploads/sites/5/2022/02/roodborst-24-scaled.jpg',
//       'wikipediaUrl':'https://nl.wikipedia.org/wiki/Roodborst',
//       'vogelbeschermingUrl':'https://www.vogelbescherming.nl/ontdek-vogels/kennis-over-vogels/vogelgids/vogel/roodborst',
//       'fotoKristiaanUrl':'https://cdn.discordapp.com/attachments/931614930107514931/1379917625596838050/voor_disc.JPG?ex=684547af&is=6843f62f&hm=a14fccd6ef62fb52e598666f2e029d8addeb1d0f4a4b6d1ad8bda29172f25c97&',
//       'fotoKristiaanLocatie':'Dode populierenbos, Rotterdam',
//       'fotoAaronUrl':'https://cdn.discordapp.com/attachments/931614930107514931/1379838863786381362/IMG_3039.JPG?ex=6844fe55&is=6843acd5&hm=b9d30a1d7de1802543fa6522382332b1ef3fa2761a0ce93b8416b39d1c7067e0&',
//       'fotoAaronLocatie':'Münster, Duitsland',
//     }).latijnseNaam;
// }