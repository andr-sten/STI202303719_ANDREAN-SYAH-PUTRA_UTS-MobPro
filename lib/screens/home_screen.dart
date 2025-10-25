// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:personal_journal/models/note_model.dart';
import 'package:personal_journal/screens/about_screen.dart';
import 'package:personal_journal/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  final List<Note> notes; // Menerima daftar catatan
  final Function(Note) onNoteTap; // Fungsi saat kartu di-tap
  final Function(Note) onNoteEdit; // Fungsi saat kartu di-tap
  final Function() onAddNote; // Fungsi saat tombol (+) di-tap
  final Function(Note) onNoteDelete; // Fungsi untuk menghapus catatan

  const HomeScreen({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteEdit,
    required this.onAddNote,
    required this.onNoteDelete,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Melacak filter yang aktif
  NoteCategory _selectedFilter = NoteCategory.all;

  // Fungsi untuk memfilter catatan
  List<Note> get _filteredNotes {
    if (_selectedFilter == NoteCategory.all) {
      return widget.notes;
    }
    return widget.notes
        .where((note) => note.category == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Desain Stack dari gambar tetap dipertahankan
    return Stack(
      children: [
        Positioned.fill(
          // Beri ruang untuk panel bawah (yang sekarang palsu/hanya UI)
          bottom: 60,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: "My Notes" dan tombol "..."
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Filter: "All", "Important", "To-do"
                  _buildFilterChips(),
                  const SizedBox(height: 24),

                  // Grid Daftar Catatan (Sekarang dinamis)
                  _buildNotesGrid(),
                ],
              ),
            ),
          ),
        ),

        // 2. PANEL BAWAH (Hanya UI, navigasi asli ada di BottomNavBar)
        Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomPanel()),

        // 3. TOMBOL TAMBAH (+) BESAR DI TENGAH
        Positioned(
          bottom: 40,
          left: (MediaQuery.of(context).size.width / 2) - 35,
          child: _buildCentralAddButton(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Personal Journal',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        // FUNGSI TOMBOL "..." (TENTANG APLIKASI)
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        _buildFilterChip("All", NoteCategory.all),
        const SizedBox(width: 10),
        _buildFilterChip("Important", NoteCategory.important),
        const SizedBox(width: 10),
        _buildFilterChip("To-do", NoteCategory.todo),
      ],
    );
  }

  Widget _buildFilterChip(String label, NoteCategory category) {
    final bool isSelected = _selectedFilter == category;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = category; // Ganti filter yang aktif
        });
      },
      // ... (styling sama seperti sebelumnya) ...
    );
  }

  Widget _buildNotesGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        // Gunakan _filteredNotes yang sudah difilter
        itemCount: _filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes[index];
          // Gunakan NoteCard baru
          return NoteCard(
            note: note,
            onTap: () => widget.onNoteTap(note), // Panggil fungsi tap
            onEditTap: () => widget.onNoteEdit(note), // Panggil fungsi edit
            onDeleteTap: () =>
                widget.onNoteDelete(note), // Panggil fungsi hapus
          );
        },
      ),
    );
  }

  // Tombol (+) memanggil fungsi onAddNote dari parent
  Widget _buildCentralAddButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.onAddNote,
      // ... (styling sama seperti sebelumnya) ...
    );
  }

  // Panel ini sekarang hanya UI, tidak ada fungsi
  Widget _buildBottomPanel() {
    return Container(
      // ... (styling sama seperti sebelumnya) ...
    );
  }
}
