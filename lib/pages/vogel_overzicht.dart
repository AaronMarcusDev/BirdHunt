// import 'package:birdhunt/firebase/vogel_firebase_functions.dart';
// import 'package:birdhunt/tools/map_to_vogel.dart';
import 'package:birdhunt/firebase/vogel_firebase_functions.dart';
import 'package:birdhunt/pages/informatie_page.dart';
import 'package:birdhunt/tools/capitalize.dart';
import 'package:birdhunt/tools/map_to_vogel.dart';
import 'package:birdhunt/vogel/vogel.dart';
import 'package:birdhunt/pages/vogel_toevoegen.dart';
import 'package:flutter/material.dart';
import 'package:birdhunt/tools/hex_to_color.dart';
import 'package:birdhunt/pages/vogel_detail_page.dart';

class BirdList extends StatefulWidget {
  const BirdList({super.key});

  @override
  State<BirdList> createState() => _BirdListState();
}

class _BirdListState extends State<BirdList> {
  // List<Vogel> vogels = List.from(voorbeeldVogelLijst);
  List<Vogel> vogels = [];

  Future<void> _laadVogels() async {
    var tempVogels = <Vogel>[];
    var firebaseVogelMap = await fetchAlleVogelsAlsMap();

    for (var firebaseVogel in firebaseVogelMap) {
      if (firebaseVogel['naam'] != 'voorbeeld_data') {
        tempVogels.add(vogelVanFirestoreMap(firebaseVogel));
      }
    }

    // Sorteer: eerst op familie, dan op naam
    tempVogels.sort((a, b) {
      int familieVergelijk = a.familie.compareTo(b.familie);
      if (familieVergelijk != 0) {
        return familieVergelijk;
      } else {
        return a.naam.compareTo(b.naam);
      }
    });

    setState(() {
      vogels = tempVogels;
    });
  }
  // Kopie van vogelLijst

  @override
  void initState() {
    super.initState();
    _laadVogels();
  }

  Future<void> _voegNieuweVogelToe(Vogel vogel) => _laadVogels();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: hexToColor("#efe9de"),
        elevation: 10,
        leading: IconButton(
          tooltip: 'Instellingen en informatie',
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => InformatiePage()));
          },
          icon: Icon(Icons.settings),
          iconSize: 30,
          color: hexToColor("#454340"),
        ),
        title: Text(
          "Vogelcollectie",
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
              tooltip: 'Herlaad de collectie',
              iconSize: 30,
              onPressed: () {
                _laadVogels();
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
            itemCount: vogels.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final Vogel vogel = vogels[index];
              return GestureDetector(
                onTap: () async {
                  final isGewijzigd = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VogelDetailPage(vogel: vogel),
                    ),
                  );

                  if (isGewijzigd == true) {
                    _laadVogels(); // Herlaad de vogels als er iets is aangepast
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: hexToColor(vogel.familieKleur),
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
                        child: Image.network(
                          vogel.lijstFotoUrl,
                          height: 130,
                          width: 130,
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
                                vogel.naam.capitalize(),
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
                                "Latijn: ${vogel.latijnseNaam}",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // <-- toont "..." als het te lang is
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Familie: ${vogel.familie}",
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
              builder: (context) =>
                  VogelToevoegenPage(onVogelToegevoegd: _voegNieuweVogelToe),
            ),
          );
        },
        tooltip: "Voeg een vogel toe",
        backgroundColor: hexToColor("#454340"),
        foregroundColor: hexToColor("#f4f1e5"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
