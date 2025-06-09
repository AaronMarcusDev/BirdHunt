import 'package:birdhunt/pages/foto_uitleg_page.dart';
import 'package:birdhunt/tools/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformatiePage extends StatefulWidget {
  const InformatiePage({super.key});

  @override
  State<InformatiePage> createState() => _InformatiePageState();
}

class _InformatiePageState extends State<InformatiePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informatie & Tools",
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
            padding: const EdgeInsets.all(8),
            children: [
              GestureDetector(
                onTap: () async {
                  final Uri uri = Uri.parse(
                    "https://github.com/AaronMarcusDev/BirdHunt-Storage",
                  );
                  if (!await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception(
                      'Kan de URL niet openen: https://github.com/AaronMarcusDev/BirdHunt-Storage',
                    );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: hexToColor("#454340"),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      // https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Github-desktop-logo-symbol.svg/2048px-Github-desktop-logo-symbol.svg.png
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.asset(
                          "assets/logos/github-logo.png",
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
                              Row(
                                children: [
                                  Text(
                                    "Open GitHub Database",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow
                                        .ellipsis, // <-- toont "..." als het te lang is
                                  ),
                                  //   Icon(
                                  //     Icons.arrow_outward_rounded,
                                  //     size: 28,
                                  //     color: Colors.white,
                                  //   ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Ga naar de plek waar de foto bestanden voor BirdHunt zijn opgeslagen ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                maxLines: 3,
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FotoUitlegPage(),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: hexToColor("#454340"),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      // https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Github-desktop-logo-symbol.svg/2048px-Github-desktop-logo-symbol.svg.png
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: Image.asset(
                          "assets/logos/picture_frame.png",
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
                              Row(
                                children: [
                                  Text(
                                    "Vogel foto's toevoegen",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow
                                        .ellipsis, // <-- toont "..." als het te lang is
                                  ),
                                  //   Icon(
                                  //     Icons.arrow_outward_rounded,
                                  //     size: 28,
                                  //     color: Colors.white,
                                  //   ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Een korte uitleg over het gebruik van de github opslag en de app.",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                maxLines: 3,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
