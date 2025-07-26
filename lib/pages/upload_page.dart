import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'result_page.dart';


class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with SingleTickerProviderStateMixin {
  XFile? selectedImage;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      _controller.forward(from: 0); // mulai animasi saat gambar dipilih
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1FF),
      appBar: AppBar(
        title: const Text("Upload Image"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectedImage != null
                  ? FadeTransition(
                      opacity: _fadeAnimation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(selectedImage!.path),
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(
                      "Belum ada gambar dipilih",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Pilih Gambar",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
  onPressed: () async {
    if (selectedImage != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(
                "Mengubah ke gaya Anime...",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context); // tutup dialog

      // 🚀 Pindah ke halaman ResultPage pakai animasi slide
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => ResultPage(
            imagePath: selectedImage!.path,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // dari kanan
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurple.shade100,
    foregroundColor: Colors.black87,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  ),
  child: Text(
    "Convert ke Anime",
    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
