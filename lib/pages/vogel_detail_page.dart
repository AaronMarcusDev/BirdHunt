import 'package:birdhunt/firebase/vogel_firebase_functions.dart';
import 'package:birdhunt/tools/capitalize.dart';
import 'package:birdhunt/tools/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:birdhunt/vogel/vogel.dart';
import 'package:url_launcher/url_launcher.dart';

class VogelDetailPage extends StatelessWidget {
  final Vogel vogel;

  const VogelDetailPage({super.key, required this.vogel});

  _verwijderVogelAlert(BuildContext context) {
    // user must tap button!
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Vogel verwijderen?',
            style: TextStyle(
              color: hexToColor("#d90f16"),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Je staat op het punt een vogel te verwijderen.',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Weet je zeker dat je dit wil doen?',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Nee, terug',
                style: TextStyle(
                  color: hexToColor("#2f8705"),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ja, verwijder',
                style: TextStyle(
                  color: hexToColor("#d90f16"),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                // Toon loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text("Bezig met verwijderen..."),
                        ],
                      ),
                    );
                  },
                );

                // Verwijder vogel
                await verwijderVogelOpNaam(vogel.naam);
                // Even kort wachten voor smoothness
                await Future.delayed(Duration(milliseconds: 500));

                Navigator.of(context).pop(); // Sluit eerst de loading dialog
                Navigator.of(context).pop(); // sluit de AlertDialog
                Navigator.of(context).pop(true); // sluit VogelDetailPage
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vogel.naam.capitalize(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: hexToColor(vogel.familieKleur),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background.png',
              fit: BoxFit.cover, // of BoxFit.contain, BoxFit.fill, etc.
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(vogel.hoofdFotoUrl, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                // Text(vogel.naam, style: const TextStyle(fontSize: 20)),
                Text(
                  vogel.latijnseNaam,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),

                // Divider(height: 2, thickness: 1.5, color: Colors.grey[400]),
                // const SizedBox(height: 8),
                Text(
                  "Familie: ${vogel.familie}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(vogel.beschrijving, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => launchLink(vogel.wikipediaUrl),
                      child: const Text(
                        'Wikipedia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => launchLink(vogel.vogelbeschermingUrl),
                      child: const Text(
                        'Vogelbescherming',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                Divider(height: 2, thickness: 1.5, color: Colors.grey[400]),

                const SizedBox(height: 8),
                ...vogel.fotosPerGebruiker.entries.map((entry) {
                  final naam = entry.key;
                  final fotoInfo = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto $naam:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            fotoInfo.fotoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📍 ${fotoInfo.locatie}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

                Divider(height: 3, thickness: 2, color: Colors.grey[400]),
                const SizedBox(height: 8),

                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.delete, color: hexToColor("#f4f1e5")),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        hexToColor("#d90f16"),
                      ), // juiste kleur hier
                    ),
                    label: Text(
                      "Verwijder vogel",
                      style: TextStyle(
                        color: hexToColor("#f4f1e5"),
                        fontWeight: FontWeight.bold,
                      ), // tekstkleur juist hier
                    ),
                    onPressed: () async {
                      _verwijderVogelAlert(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launchLink(String url) async {
    //print("Opening: $url");
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Kan de URL niet openen: $url');
    }
  }
}
