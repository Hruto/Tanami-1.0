
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/app_colors.dart';
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
      // Buka kamera yang sudah digunakan di fitur Garden.
      final XFile? image = await Navigator.push<XFile>(
        context,
        MaterialPageRoute<XFile>(
          builder: (_) => const CameraCapturePage(),
        ),
      );

      if (!mounted || image == null) return;

      XFile currentImage = image;

      // Tampilkan preview. Jika user foto ulang,
      // preview akan menerima foto terbaru.
      while (mounted) {
        final XFile? newImage = await Navigator.push<XFile>(
          context,
          MaterialPageRoute<XFile>(
            builder: (_) => DiseasePreviewPage(
              image: currentImage,
            ),
          ),
        );

        if (!mounted || newImage == null) {
          break;
        }

        currentImage = newImage;
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.darkGreen,
          ),
        ),
        title: const Text(
          'Deteksi Penyakit',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w600,
            color: AppColors.darkGreen,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.document_scanner_outlined,
                  size: 76,
                  color: AppColors.mediumGreen,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Scan Penyakit Tanaman',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Ambil foto daun tanaman untuk '
                'mendeteksi kemungkinan penyakit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.grey,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isOpeningCamera ? null : _startScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.mediumGreen.withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isOpeningCamera
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
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
    );
  }
}
