import 'package:birdhunt/tools/hex_to_color.dart';
import 'package:birdhunt/tools/map_to_vogel.dart';
import 'package:birdhunt/tools/map_to_vogel_familie.dart';
import 'package:birdhunt/vogel_families/vogel_families.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Divider spacing = Divider(height: 10, color: Color.fromRGBO(1, 1, 1, 0));

class VogelFamilieToevoegenPage extends StatefulWidget {
  final Function(VogelFamilie) onFamilieToegevoegd;

  const VogelFamilieToevoegenPage({super.key, required this.onFamilieToegevoegd});

  @override
  State<VogelFamilieToevoegenPage> createState() => _VogelToevoegenPageState();
}

class _VogelToevoegenPageState extends State<VogelFamilieToevoegenPage> {
  final _formKey = GlobalKey<FormState>();
  String? gekozenVogelFamilie; // van de dropDownMenu! (vogelfamiliekeuze)

  final Map<String, TextEditingController> controllers = {
    'naam': TextEditingController(text: ''),
    'hex': TextEditingController(text: ''),
  };

  @override
  void dispose() {
    controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Future<void> _opslaan() async {

    if (_formKey.currentState!.validate()) {
      final huidigeFamilie = VogelFamilie(
        naam: controllers['naam']!.text,
        hex: controllers['hex']!.text,
      );

      await FirebaseFirestore.instance
          .collection('vogel_families')
          .add(vogelFamilieNaarFirestoreMap(huidigeFamilie));

      widget.onFamilieToegevoegd(huidigeFamilie);
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
          "Nieuwe vogelfamilie toevoegen",
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
                      _tekstVeld('Naam', 'naam'),
                      _tekstVeld('Hex', 'hex'),

                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add, color: hexToColor("#f4f1e5")),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            hexToColor("#454340"),
                          ), // juiste kleur hier
                        ),
                        label: Text(
                          "Toevoegen",
                          style: TextStyle(
                            color: hexToColor("#f4f1e5"),
                          ), // tekstkleur juist hier
                        ),
                        onPressed: () async {
                          await _opslaan();
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
