// import 'package:birdhunt/firebase/vogel_firebase_functions.dart';
// import 'package:birdhunt/tools/map_to_vogel.dart';
import 'package:birdhunt/firebase/vogel_families_functions.dart';
import 'package:birdhunt/pages/vogel_familie_toevoegen.dart';
import 'package:birdhunt/tools/capitalize.dart';
import 'package:birdhunt/tools/map_to_vogel_familie.dart';
import 'package:birdhunt/vogel_families/vogel_families.dart';
import 'package:flutter/material.dart';
import 'package:birdhunt/tools/hex_to_color.dart';

class VogelFamiliesOverzicht extends StatefulWidget {
  const VogelFamiliesOverzicht({super.key});

  @override
  State<VogelFamiliesOverzicht> createState() => _BirdListState();
}

class _BirdListState extends State<VogelFamiliesOverzicht> {
  // List<Vogel> vogels = List.from(voorbeeldVogelLijst);
  List<VogelFamilie> familieLijst = [];

  Future<void> _laadFamilies() async {
    var tempFamilies = <VogelFamilie>[];
    var firebaseFamilieMap = await fetchAlleVogelFamiliesAlsMap();

    for (var firebaseFamilie in firebaseFamilieMap) {
      if (firebaseFamilie['naam'] != 'voorbeeld_data') {
        tempFamilies.add(vogelFamilieVanFirestoreMap(firebaseFamilie));
      }
    }

    // Sorteer: eerst op familie, dan op naam
    tempFamilies.sort((a, b) {
      int familieVergelijk = a.naam.compareTo(b.naam);
      if (familieVergelijk != 0) {
        return familieVergelijk;
      } else {
        return a.naam.compareTo(b.naam);
      }
    });

    setState(() {
      familieLijst = tempFamilies;
    });
  }
  // Kopie van vogelLijst

  @override
  void initState() {
    super.initState();
    _laadFamilies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#efe9de"),
        elevation: 10,
        title: Text(
          "Alle vogelfamilies",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: hexToColor("#454340"),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Herlaad de families',
              iconSize: 30,
              onPressed: () {
                _laadFamilies();
                fetchAlleVogelFamiliesAlsMap();
              },
              color: hexToColor("#454340"),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background.png',
              fit: BoxFit.cover,
            ),
          ),
          ListView.builder(
            itemCount: familieLijst.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final VogelFamilie vogelFamilie = familieLijst[index];
              return GestureDetector(
                onTap: () async {
                  // final isGewijzigd = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => VogelDetailPage(vogel: vogel),
                  //   ),
                  // );

                  // if (isGewijzigd == true) {
                  //   _laadVogels(); // Herlaad de vogels als er iets is aangepast
                  // }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: hexToColor(vogelFamilie.hex),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.asset(
                          "assets/unknown.jpg",
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vogelFamilie.naam.capitalize(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // <-- toont "..." als het te lang is
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Hex code: ${vogelFamilie.hex}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // <-- toont "..." als het te lang is
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VogelFamilieToevoegenPage(
                onFamilieToegevoegd: (familie) {
                  //print('Nieuwe familie toegevoegd: ${familie.naam}');
                  _laadFamilies();
                },
              ),
            ),
          );
        },
        tooltip: "Voeg een familie toe",
        backgroundColor: hexToColor("#454340"),
        foregroundColor: hexToColor("#f4f1e5"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
