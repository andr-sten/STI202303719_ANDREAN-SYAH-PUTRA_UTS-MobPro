// lib/screens/editor_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:personal_journal/models/note_model.dart';

class EditorScreen extends StatefulWidget {
  final Note? note; // Note opsional (jika mode edit)

  const EditorScreen({super.key, this.note});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  // Controller untuk mengisi form
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  File? _selectedImage;
  NoteCategory _selectedCategory = NoteCategory.none;

  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedCategory = widget.note?.category ?? NoteCategory.none;
    if (widget.note?.imagePath != null) {
      _selectedImage = File(widget.note!.imagePath!);
    }

    // 3. INISIALISASI TANGGAL
    // Jika ini catatan baru, pakai waktu sekarang. Jika edit, pakai waktu lama.
    _selectedDateTime = widget.note?.timestamp ?? DateTime.now();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // 4. TAMBAHKAN FUNGSI BARU UNTUK PICKER
  Future<void> _pickDateTime() async {
    // Tampilkan Date Picker
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000), // Tahun awal
      lastDate: DateTime(2101), // Tahun akhir
    );
    // Jika user batal pilih tanggal
    if (date == null) return;

    // Tampilkan Time Picker
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    // Jika user batal pilih waktu
    if (time == null) return;

    // Gabungkan tanggal dan waktu, lalu update state
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // Fungsi untuk menyimpan
  // 6. UPDATE FUNGSI _onSave()
  void _onSave() {
    if (_titleController.text.isEmpty) {
      return;
    }

    final noteToSave = Note(
      id: widget.note?.id ?? '',
      title: _titleController.text,
      content: _contentController.text,
      imagePath: _selectedImage?.path,
      category: _selectedCategory,
      colorValue: widget.note?.colorValue ?? 0,
      timestamp: _selectedDateTime, // <-- SERTAKAN TIMESTAMP SAAT SAVE
    );

    Navigator.pop(context, noteToSave);
  }

  @override
  Widget build(BuildContext context) {
    // Tetap gunakan tema terang
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
            // TOMBOL SAVE
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: _onSave,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Input Judul
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Judul Catatan',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Tampilkan Gambar jika ada
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!),
                  ),
                ),

              // 3. Input Teks Utama
              TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 24, height: 1.5),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Mulai menulis...',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 24),

              // 4. TAMBAHKAN WIDGET PEMILIH TANGGAL DI SINI
              const SizedBox(height: 20),
              Text(
                'Waktu Catatan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              // Tombol untuk memanggil picker
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _pickDateTime,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 20),
                    const SizedBox(width: 10),
                    // Tampilkan tanggal yang dipilih
                    Text(
                      DateFormat(
                        'd MMMM yyyy, HH:mm',
                      ).format(_selectedDateTime),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. PEMILIH KATEGORI
              const Text(
                'Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  ChoiceChip(
                    label: const Text('Important'),
                    selected: _selectedCategory == NoteCategory.important,
                    onSelected: (val) => setState(
                      () => _selectedCategory = NoteCategory.important,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('To-do'),
                    selected: _selectedCategory == NoteCategory.todo,
                    onSelected: (val) =>
                        setState(() => _selectedCategory = NoteCategory.todo),
                  ),
                  ChoiceChip(
                    label: const Text('None'),
                    selected: _selectedCategory == NoteCategory.none,
                    onSelected: (val) =>
                        setState(() => _selectedCategory = NoteCategory.none),
                  ),
                ],
              ),
            ],
          ),
        ),
        // TOOLBAR "SISIPKAN GAMBAR SAJA" (Disederhanakan)
        bottomNavigationBar: _buildEditorToolbar(),
      ),
    );
  }

  Widget _buildEditorToolbar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.image_outlined),
            tooltip: 'Ambil dari Galeri',
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            tooltip: 'Ambil dari Kamera',
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Hapus Gambar',
              onPressed: () => setState(() => _selectedImage = null),
            ),
        ],
      ),
    );
  }
}
