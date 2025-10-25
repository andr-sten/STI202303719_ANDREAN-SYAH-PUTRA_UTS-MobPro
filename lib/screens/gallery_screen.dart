// lib/screens/gallery_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:personal_journal/models/note_model.dart';

class GalleryScreen extends StatelessWidget {
  final List<Note> notes;
  const GalleryScreen({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    // Filter catatan yang hanya punya gambar
    final List<Note> notesWithImages = notes
        .where((note) => note.imagePath != null)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Media'),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: notesWithImages.length,
        itemBuilder: (context, index) {
          final note = notesWithImages[index];
          return InkWell(
            onTap: () {
              // FUNGSI KLIK DETAIL GALERI
              showDialog(
                context: context,
                builder: (ctx) =>
                    Dialog(child: Image.file(File(note.imagePath!))),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(note.imagePath!), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
