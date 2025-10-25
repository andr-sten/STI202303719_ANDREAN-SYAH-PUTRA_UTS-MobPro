// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_journal/models/note_model.dart';
import 'package:personal_journal/screens/main_layout_screen.dart';

// Fungsi main() dengan inisialisasi Hive
void main() async {
  // Pastikan Flutter terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Daftarkan Adapter (ini butuh file .g.dart)
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteCategoryAdapter());

  // Buka "Box" database
  await Hive.openBox<Note>('notesBox');

  // Jalankan aplikasi
  runApp(const MyApp());
}

// Widget MyApp dengan MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Di sinilah MaterialApp berada
    return MaterialApp(
      title: 'Personal Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'MyFont',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        cardColor: const Color(0xFF2C2C2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orangeAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainLayoutScreen(),
    );
  }
}
