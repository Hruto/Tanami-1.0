
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constant/app_colors.dart';
import '../../garden/screens/camera_capture_page.dart';
import '../mocks/disease_mock_data.dart';
import 'disease_result_page.dart';

class DiseasePreviewPage extends StatefulWidget {
  final XFile image;

  const DiseasePreviewPage({
    super.key,
    required this.image,
  });

  @override
  State<DiseasePreviewPage> createState() =>
      _DiseasePreviewPageState();
}

class _DiseasePreviewPageState
    extends State<DiseasePreviewPage> {
  late XFile _image;

  // Ganti path ini sesuai nama file background yang kamu punya.
  static const String _backgroundAsset =
      'assets/images/background.svg';

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  Future<void> _retakePhoto() async {
    final XFile? newImage = await Navigator.push<XFile>(
      context,
      MaterialPageRoute<XFile>(
        builder: (_) => const CameraCapturePage(),
      ),
    );

    if (!mounted || newImage == null) return;

    setState(() {
      _image = newImage;
    });
  }

  Future<void> _continueDetection() async {
    final response = DiseaseMockData.responseFor();

    final bool? completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DiseaseResultPage(
          image: _image,
          response: response,
        ),
      ),
    );

    if (!mounted) return;

    if (completed == true) {
      Navigator.pop(context, true);
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 22,
        right: 22,
        bottom: 14,
      ),
      decoration: const BoxDecoration(
        color: AppColors.mediumGreen,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: SvgPicture.asset(
                      'assets/icons/back.svg',
                      width: 25,
                      height: 25,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/logo_header.svg',
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pratinjau Gambar',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/leaf.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.darkGreen,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Pastikan gambar terlihat jelas '
              'dan fokus pada daun',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 11,
                height: 1.4,
                color: AppColors.darkGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary
              ? AppColors.mediumGreen
              : AppColors.lightGreen,
          foregroundColor: primary
              ? Colors.white
              : AppColors.grey,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    final screenHeight = MediaQuery.of(context).size.height;
    final photoHeight =
        (screenHeight * 0.48).clamp(340.0, 500.0);

    return Container(
      width: double.infinity,
      height: photoHeight,
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.file(
        File(_image.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 50,
              color: AppColors.grey,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image milik Tanami.
          Image.asset(
            _backgroundAsset,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),

          Column(
            children: [
              _buildHeader(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    12,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildPhoto(),
                              const SizedBox(height: 18),
                              _buildTip(),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildButton(
                        text: 'Lanjut Analisis',
                        primary: true,
                        onPressed: _continueDetection,
                      ),

                      const SizedBox(height: 10),

                      _buildButton(
                        text: 'Foto Ulang',
                        onPressed: _retakePhoto,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
