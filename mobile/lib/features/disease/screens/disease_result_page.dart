
import 'package:flutter/material.dart';

import '../../../core/constant/app_colors.dart';

class DiseaseResultPage extends StatelessWidget {
  final String status;

  const DiseaseResultPage({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'confident':
        return _buildConfidentResult(context);

      case 'uncertain':
        return _buildUncertainResult(context);

      case 'unknown':
        return _buildUnknownResult(context);

      case 'invalid_image':
        return _buildInvalidImageResult(context);

      default:
        return _buildUnknownResult(context);
    }
  }

  Widget _buildConfidentResult(BuildContext context) {
    return _buildResultLayout(
      context,
      icon: Icons.check_circle_outline_rounded,
      title: 'Penyakit Terdeteksi',
      description:
          'Tanaman kamu terdeteksi memiliki kemungkinan penyakit.',
      statusLabel: 'Hasil Deteksi',
      diseaseName: 'Antraknosa',
      diseaseDescription:
          'Penyakit ini dapat menyerang bagian daun dan buah tanaman.',
      buttonText: 'Selesai',
    );
  }

  Widget _buildUncertainResult(BuildContext context) {
    return _buildResultLayout(
      context,
      icon: Icons.help_outline_rounded,
      title: 'Hasil Belum Pasti',
      description:
          'Sistem belum dapat memastikan jenis penyakit tanaman.',
      statusLabel: 'Kemungkinan Penyakit',
      diseaseName: 'Antraknosa',
      diseaseDescription:
          'Hasil ini masih membutuhkan pemeriksaan lebih lanjut.',
      buttonText: 'Selesai',
    );
  }

  Widget _buildUnknownResult(BuildContext context) {
    return _buildResultLayout(
      context,
      icon: Icons.search_off_rounded,
      title: 'Penyakit Tidak Dikenali',
      description:
          'Sistem belum mengenali penyakit pada foto tanaman ini.',
      statusLabel: 'Status Deteksi',
      diseaseName: 'Tidak diketahui',
      diseaseDescription:
          'Coba ambil foto daun dengan pencahayaan yang lebih baik.',
      buttonText: 'Scan Ulang',
      onButtonPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildInvalidImageResult(BuildContext context) {
    return _buildResultLayout(
      context,
      icon: Icons.image_not_supported_outlined,
      title: 'Foto Tidak Sesuai',
      description:
          'Foto belum dapat digunakan untuk proses deteksi.',
      statusLabel: 'Status Foto',
      diseaseName: 'Foto tidak valid',
      diseaseDescription:
          'Pastikan foto fokus, cukup terang, dan menampilkan daun tanaman.',
      buttonText: 'Foto Ulang',
      onButtonPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildResultLayout(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String statusLabel,
    required String diseaseName,
    required String diseaseDescription,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
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
          'Hasil Deteksi',
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
              const SizedBox(height: 16),
              Icon(
                icon,
                size: 72,
                color: AppColors.mediumGreen,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusLabel,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diseaseName,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diseaseDescription,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onButtonPressed ??
                      () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
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
