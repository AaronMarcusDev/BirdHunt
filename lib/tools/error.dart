import 'package:flutter/material.dart';

void error(BuildContext context, String boodschap) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          const Text(
            'Fout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(boodschap),
      actions: [
        TextButton(
          child: const Text('Oké'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
