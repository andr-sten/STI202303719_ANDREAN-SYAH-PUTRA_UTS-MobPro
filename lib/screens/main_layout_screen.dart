// lib/screens/main_layout_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:personal_journal/models/note_model.dart';
import 'package:personal_journal/screens/editor_screen.dart';
import 'package:personal_journal/screens/gallery_screen.dart';
import 'package:personal_journal/screens/home_screen.dart';
import 'package:personal_journal/screens/stats_screen.dart';
import 'package:personal_journal/screens/detail_screen.dart';
import 'dart:math';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // HAPUS LIST INI:
  // final List<Note> _allNotes = [];

  // Kita masih perlu ini untuk generate warna
  final List<Color> _noteColors = [
    Colors.orange.shade200,
    Colors.lightBlue.shade100,
    Colors.pink.shade100,
    // ... (sisa warna)
  ];

  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fabScaleAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutBack,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _navigateToEditor(BuildContext context, [Note? note]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditorScreen(note: note)),
    );

    if (result != null && result is Note) {
      // Panggil fungsi _saveNote yang baru
      await _saveNote(result);
    }
  }

  void _navigateToDetail(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          note: note,
          // Saat tombol Edit di DetailScreen ditekan:
          onEdit: () {
            // 1. Tutup layar detail
            Navigator.pop(context);
            // 2. Buka layar editor
            _navigateToEditor(context, note);
          },
        ),
      ),
    );
  }

  // UBAH FUNGSI INI
  Future<void> _saveNote(Note note) async {
    // 1. Dapatkan box Hive
    final box = Hive.box<Note>('notesBox');

    String noteId = note.id;
    if (noteId.isEmpty) {
      // Ini catatan baru
      noteId = DateTime.now().millisecondsSinceEpoch.toString();
      note.id = noteId;
      // Assign warna baru
      note.colorValue = _noteColors[Random().nextInt(_noteColors.length)].value;
    }

    // 2. Simpan ke Hive menggunakan 'put' (ini akan 'insert' atau 'update' otomatis)
    await box.put(noteId, note);
    // Kita tidak perlu setState() lagi, ValueListenableBuilder akan menanganinya
  }

  //fungsi untuk menghapus note
  Future<void> _deleteNote(Note note) async {
    // Tampilkan dialog konfirmasi
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Catatan'),
          content: Text('Anda yakin ingin menghapus "${note.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Batal
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Hapus
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // Jika user menekan "Hapus" (didConfirm == true)
    if (didConfirm == true) {
      final box = Hive.box<Note>('notesBox');
      await box.delete(note.id); // Hapus dari database
    }
  }

  @override
  Widget build(BuildContext context) {
    // BUNGKUS 'return Scaffold' DENGAN 'ValueListenableBuilder'
    return ValueListenableBuilder<Box<Note>>(
      valueListenable: Hive.box<Note>('notesBox').listenable(),
      builder: (context, box, _) {
        // 'box' adalah database kita. Ubah ke List
        final allNotes = box.values.toList();

        // Daftar halaman sekarang menerima 'allNotes' dari Hive
        final List<Widget> pages = [
          HomeScreen(
            notes: allNotes,
            onNoteTap: _navigateToDetail,
            onNoteEdit: (note) {
              _navigateToEditor(context, note);
            },
            onAddNote: () {
              _navigateToEditor(context);
            },
            onNoteDelete: _deleteNote,
          ),
          StatsScreen(notes: allNotes),
          GalleryScreen(notes: allNotes),
        ];

        // Scaffold tetap sama
        return Scaffold(
          body: pages[_selectedIndex],
          floatingActionButton: ScaleTransition(
            scale: _fabScaleAnimation,
            child: FloatingActionButton(
              onPressed: () {
                _navigateToEditor(context);
              },
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.black, size: 30),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistik',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library),
                label: 'Galeri',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: const Color(0xFF2C2C2E),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }
}
