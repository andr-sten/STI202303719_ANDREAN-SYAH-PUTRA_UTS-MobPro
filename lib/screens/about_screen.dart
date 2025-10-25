// lib/screens/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Personal Journal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Dibuat Untuk Memenuhi Tugas UTS Mobile Programming STMIK WIDYA UTAMA',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
