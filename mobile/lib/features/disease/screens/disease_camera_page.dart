
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../garden/screens/camera_capture_page.dart';
import 'disease_preview_page.dart';

class DiseaseCameraPage extends StatefulWidget {
  const DiseaseCameraPage({super.key});

  @override
  State<DiseaseCameraPage> createState() =>
      _DiseaseCameraPageState();
}

class _DiseaseCameraPageState extends State<DiseaseCameraPage> {
  bool _isOpeningCamera = false;

  Future<void> _startScan() async {
    if (_isOpeningCamera) return;

    setState(() {
      _isOpeningCamera = true;
    });

    try {
      final XFile? image = await Navigator.push<XFile>(
        context,
        MaterialPageRoute<XFile>(
          builder: (_) => const CameraCapturePage(),
        ),
      );

      if (!mounted || image == null) return;

      final bool? completed = await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (_) => DiseasePreviewPage(image: image),
        ),
      );

      if (!mounted) return;

      // Feedback berhasil dikirim.
      // Tutup DiseaseCameraPage dan kembali ke Detail Tanaman.
      if (completed == true) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat membuka kamera.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningCamera = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.document_scanner_outlined,
                  size: 80,
                  color: Color(0xFF698B6A),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Pindai Penyakit',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3B2F),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ambil foto daun tanaman untuk '
                  'mendeteksi kemungkinan penyakit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 13,
                    color: Color(0xFF646C61),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        _isOpeningCamera ? null : _startScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF698B6A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isOpeningCamera
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Mulai Scan',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
