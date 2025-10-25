// lib/screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:personal_journal/models/note_model.dart';

class StatsScreen extends StatelessWidget {
  final List<Note> notes;
  const StatsScreen({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    // Hitung jumlah foto
    final int photoCount = notes.where((note) => note.imagePath != null).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Catatan',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade400),
            ),
            Text(
              '${notes.length}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              'Total Foto',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade400),
            ),
            Text(
              '$photoCount',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
