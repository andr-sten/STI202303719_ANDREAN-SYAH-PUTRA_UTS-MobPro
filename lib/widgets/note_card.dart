// lib/widgets/note_card.dart
import 'dart:io'; // Untuk menampilkan File
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_journal/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          color: note.color, // Warna dari note
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //judul
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Bungkus Judul dengan Expanded agar tidak bentrok
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Izinkan 2 baris jika judul panjang
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                //pop menu
                PopupMenuButton<String>(
                  color: Colors.white, // Warna latar menu
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(), // Perkecil area tap
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEditTap();
                    } else if (value == 'delete') {
                      onDeleteTap();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),

            // TANGGAL
            const SizedBox(height: 4),
            Text(
              // Format: 22 Okt 2025
              DateFormat('d MMM yyyy').format(note.timestamp),
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 8),

            // TAMPILKAN GAMBAR JIKA ADA
            if (note.imagePath != null && note.imagePath!.isNotEmpty)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(note.imagePath!), // Tampilkan gambar dari file path
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              )
            // Tampilkan teks konten jika tidak ada gambar
            else
              Expanded(
                child: Text(
                  note.content,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
