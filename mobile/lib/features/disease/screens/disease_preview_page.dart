
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/constant/app_colors.dart';
import '../../garden/screens/camera_capture_page.dart';
import 'disease_result_page.dart';

class DiseasePreviewPage extends StatelessWidget {
  final XFile image;

  const DiseasePreviewPage({
    super.key,
    required this.image,
  });

  Future<void> _retakePhoto(BuildContext context) async {
    final XFile? newImage = await Navigator.push<XFile>(
      context,
      MaterialPageRoute<XFile>(
        builder: (_) => const CameraCapturePage(),
      ),
    );

    if (!context.mounted || newImage == null) return;

    // Kembalikan foto baru ke DiseaseCameraPage.
    Navigator.pop(context, newImage);
  }

  void _continueDetection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DiseaseResultPage(
          status: 'confident',
        ),
      ),
    );
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
          'Preview Foto',
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
              const Text(
                'Pastikan foto tanaman terlihat jelas '
                'sebelum melakukan deteksi penyakit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    File(image.path),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: AppColors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Foto tidak dapat ditampilkan.',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FOTO ULANG
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => _retakePhoto(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.mediumGreen,
                    side: const BorderSide(
                      color: AppColors.mediumGreen,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Foto Ulang',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // LANJUTKAN
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _continueDetection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
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
