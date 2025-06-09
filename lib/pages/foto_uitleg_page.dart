import 'package:birdhunt/tools/hex_to_color.dart';
import 'package:flutter/material.dart';

class FotoUitlegPage extends StatelessWidget {
  const FotoUitlegPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App uitleg",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: hexToColor("#454340"),
          ),
        ),
        centerTitle: true,
        backgroundColor: hexToColor("#efe9de"),
        elevation: 10,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/background.png',
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '📸 Uitleg: Vogel-foto\'s toevoegen aan BirdHunt',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Om een nieuwe vogel toe te voegen aan de app, moeten eerst de juiste foto\'s worden toegevoegd aan de GitHub opslagrepo:',
                style: TextStyle(fontSize: 16),
              ),
              const SelectableText(
                'https://github.com/AaronMarcusDev/BirdHunt-Storage',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '🔧 Stappenplan:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              bulletPoint(
                'Ga naar de GitHub-repo: https://github.com/AaronMarcusDev/BirdHunt-Storage (kopieer de link hierboven)',
              ),
              bulletPoint(
                'Maak een nieuwe map aan met de vogelnaam in KLEINE letters.',
              ),
              codeBlock('houtduif/'),
              bulletPoint('Voeg drie foto\'s toe aan die map:'),
              codeBlock('''
        houtduif/
        ├── aaron.jpg
        ├── kristiaan.jpg
        └── lijstfoto.jpg'''),
              bulletPoint('De bestandsnamen moeten exact kloppen.'),
              bulletPoint(
                'De mapnaam moet exact overeenkomen met de naam in de app (kleine letters, spaties, alles).',
              ),
              bulletPoint(
                'Voeg alle drie de foto\'s toe voordat je de vogel toevoegt in de app.',
              ),
              const SizedBox(height: 24),
              const Text(
                '📲 Daarna in de app:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Zodra de drie foto\'s zijn toegevoegd, kun je in de app een nieuwe vogel aanmaken met exact dezelfde naam als de map. '
                'De app zoekt automatisch in de GitHub-repo naar de juiste foto\'s.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                '⚠️ Let op!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              bulletPoint('Gebruik .jpg (geen .jpeg of .png).'),
              bulletPoint(
                'Gebruik liggende foto\'s (horizontaal) met een 4:3 ratio voor de beste weergave.',
              ),
              bulletPoint(
                "^-- Echter, gebruik een 1:1 ratio (vierkant) voor de lijstfoto.jpg",
              ),
              bulletPoint(
                'Een breedte van ±1000px is vaak voldoende. >1000px is ook goed, maar houdt de foto\'s het liefst <10mb',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget codeBlock(String code) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hexToColor("#efe9de"),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
