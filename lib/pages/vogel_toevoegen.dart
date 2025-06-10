import 'package:birdhunt/firebase/vogel_families_functions.dart';
import 'package:birdhunt/pages/vogel_familie_toevoegen.dart';
import 'package:birdhunt/pages/vogel_families_overzicht.dart';
import 'package:birdhunt/tools/hex_to_color.dart';
import 'package:birdhunt/tools/map_to_vogel.dart';
import 'package:birdhunt/vogel/vogel.dart';
import 'package:birdhunt/vogel_families/vogel_families.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// Zorg dat je Vogel class goed is geïmporteerd

String githubStorageUrl =
    "https://raw.githubusercontent.com/AaronMarcusDev/BirdHunt-Storage/refs/heads/main/";
Divider spacing = Divider(height: 10, color: Color.fromRGBO(1, 1, 1, 0));

class VogelToevoegenPage extends StatefulWidget {
  final Function(Vogel) onVogelToegevoegd;

  const VogelToevoegenPage({super.key, required this.onVogelToegevoegd});

  @override
  State<VogelToevoegenPage> createState() => _VogelToevoegenPageState();
}

class _VogelToevoegenPageState extends State<VogelToevoegenPage> {
  final _formKey = GlobalKey<FormState>();
  String? gekozenVogelFamilie; // van de dropDownMenu! (vogelfamiliekeuze)
  Map<String, String> vogelFamiliesFirebase = {};

  Future<void> _laadVogelFamilies() async {
    final families = await fetchAlleVogelFamiliesAlsMap();
    final map = <String, String>{};

    for (final familie in families) {
      if (familie['naam'] != null && familie['hex'] != null) {
        map[familie['naam']] = familie['hex'];
      }
    }

    setState(() {
      vogelFamiliesFirebase = map;
    });
  }

  @override
  void initState() {
    super.initState();
    _laadVogelFamilies();
  }

  final Map<String, TextEditingController> controllers = {
    'naam': TextEditingController(text: ''),
    'latijnseNaam': TextEditingController(text: ''),
    'familie': TextEditingController(text: ''),
    'familieKleur': TextEditingController(text: ''),
    'beschrijving': TextEditingController(text: ''),
    'hoofdFotoUrl': TextEditingController(),
    'lijstFotoUrl': TextEditingController(),
    'wikipediaUrl': TextEditingController(),
    'vogelbeschermingUrl': TextEditingController(text: ''),
    'kristiaanFotoUrl': TextEditingController(),
    'kristiaanLocatie': TextEditingController(text: ''),
    'aaronFotoUrl': TextEditingController(),
    'aaronLocatie': TextEditingController(text: ''),
  };

  @override
  void dispose() {
    controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Future<void> _opslaan() async {
    // Voorbeeldvogelmap
    //   {
    //   'naam':'Roodborst',
    //   'latijnseNaam':'Erithacus rubecula',
    //   'familie':'Muscicapidea (vliegenvangers)',
    //   'familiekleur':'#6556BF',
    //   'beschrijving':'Een kleine zangvogel die makkelijk te herkennen is aan zijn oranje borst en gezicht. Hij komt veel voor in tuinen, bossen en parken.',
    //   'hoofdFotoUrl':'https://www.rootsmagazine.nl/app/uploads/sites/5/2022/02/roodborst-24-scaled.jpg',
    //   'lijstFotoUrl': 'https://www.rootsmagazine.nl/app/uploads/sites/5/2022/02/roodborst-24-scaled.jpg',
    //   'wikipediaUrl':'https://nl.wikipedia.org/wiki/Roodborst',
    //   'vogelbeschermingUrl':'https://www.vogelbescherming.nl/ontdek-vogels/kennis-over-vogels/vogelgids/vogel/roodborst',
    //   'fotoKristiaanUrl':'https://cdn.discordapp.com/attachments/931614930107514931/1379917625596838050/voor_disc.JPG?ex=684547af&is=6843f62f&hm=a14fccd6ef62fb52e598666f2e029d8addeb1d0f4a4b6d1ad8bda29172f25c97&',
    //   'fotoKristiaanLocatie':'Dode populierenbos, Rotterdam',
    //   'fotoAaronUrl':'https://cdn.discordapp.com/attachments/931614930107514931/1379838863786381362/IMG_3039.JPG?ex=6844fe55&is=6843acd5&hm=b9d30a1d7de1802543fa6522382332b1ef3fa2761a0ce93b8416b39d1c7067e0&',
    //   'fotoAaronLocatie':'Münster, Duitsland',
    // }

    if (_formKey.currentState!.validate()) {
      final vogel = Vogel(
        naam: controllers['naam']!.text,
        latijnseNaam: controllers['latijnseNaam']!.text,
        familie: gekozenVogelFamilie!,
        familieKleur: vogelFamiliesFirebase[gekozenVogelFamilie!]!,

        beschrijving: controllers['beschrijving']!.text,
        hoofdFotoUrl: controllers['hoofdFotoUrl']!.text,
        lijstFotoUrl:
            "$githubStorageUrl${controllers['naam']!.text}/lijstfoto.jpg",
        wikipediaUrl: controllers['wikipediaUrl']!.text,
        vogelbeschermingUrl:
            "https://www.vogelbescherming.nl/ontdek-vogels/kennis-over-vogels/vogelgids/vogel/${(controllers['vogelbeschermingUrl']!.text).replaceAll(' ', '-')}",
        fotosPerGebruiker: {
          'Kristiaan': FotoInfo(
            fotoUrl:
                "$githubStorageUrl${controllers['naam']!.text}/kristiaan.jpg",
            locatie: controllers['kristiaanLocatie']!.text,
          ),
          'Aaron': FotoInfo(
            fotoUrl: "$githubStorageUrl${controllers['naam']!.text}/aaron.jpg",
            locatie: controllers['aaronLocatie']!.text,
          ),
        },
      );

      await FirebaseFirestore.instance
          .collection('vogels')
          .add(vogelNaarFirestoreMap(vogel));

      widget.onVogelToegevoegd(vogel);
      Navigator.pop(context);
    }
  }

  Widget _tekstVeld(String label, String key) {
    return TextFormField(
      controller: controllers[key],
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
          value == null || value.isEmpty ? 'Vul iets in' : null,
    );
  }

  final TextEditingController dropdownMenuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hexToColor("#efe9de"),
        title: Text(
          "Nieuwe vogel toevoegen",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: hexToColor("#454340"),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background.png',
              fit: BoxFit.cover,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Algemene informatie",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _tekstVeld('Naam', 'naam'),
                      _tekstVeld('Latijnse naam', 'latijnseNaam'),

                      spacing,
                      const Text(
                        "Familie",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      DropdownMenu<String>(
                        controller: dropdownMenuController,
                        initialSelection: gekozenVogelFamilie,
                        dropdownMenuEntries:
                            (vogelFamiliesFirebase.keys.toList()..sort(
                                  (a, b) => a.toLowerCase().compareTo(
                                    b.toLowerCase(),
                                  ),
                                ))
                                .map(
                                  (familieNaam) => DropdownMenuEntry<String>(
                                    value: familieNaam,
                                    label: familieNaam,
                                  ),
                                )
                                .toList(),

                        onSelected: (value) {
                          setState(() => gekozenVogelFamilie = value);
                        },
                      ),

                      spacing,
                      Divider(thickness: 1.5, color: Colors.grey),

                      //_tekstVeld('Familie', 'familie'),
                      //_tekstVeld('Familiekleur (bijv. #6556BF)', 'familieKleur'),
                      _tekstVeld('Beschrijving', 'beschrijving'),
                      _tekstVeld('Hoofdfoto URL', 'hoofdFotoUrl'),
                      //_tekstVeld('Lijstfoto URL', 'lijstFotoUrl'),
                      _tekstVeld('Wikipedia URL', 'wikipediaUrl'),
                      _tekstVeld(
                        'Vogelbescherming vogelnaam',
                        'vogelbeschermingUrl',
                      ),
                      //const Divider(),
                      spacing,
                      const Text(
                        "Foto van Kristiaan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // _tekstVeld('Foto URL (Kristiaan)', 'kristiaanFotoUrl'),
                      _tekstVeld('Locatie (Kristiaan)', 'kristiaanLocatie'),
                      spacing,
                      const Text(
                        "Foto van Aaron",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      //_tekstVeld('Foto URL (Aaron)', 'aaronFotoUrl'),
                      _tekstVeld('Locatie (Aaron)', 'aaronLocatie'),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add, color: hexToColor("#f4f1e5")),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            hexToColor("#454340"),
                          ), // juiste kleur hier
                        ),
                        label: Text(
                          "Toevoegen aan collectie",
                          style: TextStyle(
                            color: hexToColor("#f4f1e5"),
                          ), // tekstkleur juist hier
                        ),
                        onPressed: () async {
                          await _opslaan();
                        },
                      ),
                      spacing,
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.arrow_right_alt_sharp,
                          color: hexToColor("#f4f1e5"),
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            hexToColor("#454340"),
                          ), // juiste kleur hier
                        ),
                        label: Text(
                          "Vogelfamilie toevoegen?",
                          style: TextStyle(
                            color: hexToColor("#f4f1e5"),
                          ), // tekstkleur juist hier
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VogelFamilieToevoegenPage(
                                onFamilieToegevoegd: (familie) {},
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
