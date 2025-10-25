// lib/screens/detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_journal/models/note_model.dart';

class DetailScreen extends StatelessWidget {
  final Note note;
  // Fungsi 'onEdit' ini akan kita dapatkan dari main_layout_screen
  final VoidCallback onEdit;

  const DetailScreen({super.key, required this.note, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Kita gunakan tema terang (krem) yang sama dengan Editor
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'MyFont',
        scaffoldBackgroundColor: const Color(0xFFF7F2E9),
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F2E9),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Tombol "Edit" di halaman detail
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit, // Panggil fungsi edit
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tampilkan Judul
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // 2. Tampilkan Tanggal dan Waktu
              Text(
                DateFormat('d MMMM yyyy, HH:mm').format(note.timestamp),
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // 3. Tampilkan Gambar (jika ada)
              if (note.imagePath != null && note.imagePath!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(note.imagePath!)),
                  ),
                ),

              // 4. Tampilkan Isi Konten
              Text(
                note.content,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
