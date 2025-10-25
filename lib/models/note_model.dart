// lib/models/note_model.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // Import Hive

// Hasilkan file adapter
part 'note_model.g.dart'; // Ini akan merah dulu, tidak apa-apa

@HiveType(typeId: 1) // typeId harus unik per model
enum NoteCategory {
  @HiveField(0)
  all,

  @HiveField(1)
  important,

  @HiveField(2)
  todo,

  @HiveField(3)
  none,
}

@HiveType(typeId: 0) // typeId unik lainnya
class Note {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  NoteCategory category;

  @HiveField(5)
  int colorValue; // Diubah dari 'Color' menjadi 'int'

  @HiveField(6) // <-- TAMBAHKAN INI
  DateTime timestamp;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.imagePath,
    this.category = NoteCategory.none,
    required this.colorValue,
    required this.timestamp, // Diubah
  });

  // Buat getter agar sisa aplikasi kita tidak perlu diubah
  Color get color => Color(colorValue);
}
