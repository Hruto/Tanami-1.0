
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constant/app_colors.dart';
import 'disease_preview_page.dart';

class DiseaseCameraPage extends StatefulWidget {
  const DiseaseCameraPage({super.key});

  @override
  State<DiseaseCameraPage> createState() =>
      _DiseaseCameraPageState();
}

class _DiseaseCameraPageState extends State<DiseaseCameraPage> {
  CameraController? _controller;

  bool _isCameraReady = false;
  bool _isTakingPicture = false;
  bool _isFlashOn = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Kamera tidak ditemukan.';
          });
        }
        return;
      }

      final backCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      _controller = controller;

      await controller.setFlashMode(FlashMode.off);

      if (!mounted) return;

      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Tidak dapat membuka kamera.';
      });
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;

    if (controller == null ||
        !controller.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final image = await controller.takePicture();

      if (!mounted) return;

      await _openPreview(image);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil foto.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  Future<void> _openGallery() async {
    if (_isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        await _openPreview(image);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memilih foto dari galeri.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  Future<void> _openPreview(XFile image) async {
    final bool? completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => DiseasePreviewPage(image: image),
      ),
    );

    if (!mounted) return;

    // Feedback berhasil dikirim.
    // Kembali ke Detail Tanaman.
    if (completed == true) {
      Navigator.pop(context);
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;

    if (controller == null) return;

    try {
      final nextMode =
          _isFlashOn ? FlashMode.off : FlashMode.torch;

      await controller.setFlashMode(nextMode);

      if (!mounted) return;

      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flash tidak tersedia.'),
        ),
      );
    }
  }

  Widget _buildCameraPreview() {
    final controller = _controller!;

    final screenSize = MediaQuery.of(context).size;
    final cameraAspectRatio = controller.value.aspectRatio;
    final screenAspectRatio =
        screenSize.width / screenSize.height;

    var scale = screenAspectRatio * cameraAspectRatio;

    if (scale < 1) {
      scale = 1 / scale;
    }

    return ClipRect(
      child: Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 22,
          right: 22,
          bottom: 14,
        ),
        decoration: BoxDecoration(
          color: AppColors.mediumGreen.withValues(
            alpha: 0.65,
          ),
          borderRadius: const BorderRadius.vertical(
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
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        width: 23,
                        height: 23,
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
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pindai Penyakit',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          35,
          22,
          35,
          MediaQuery.of(context).padding.bottom + 28,
        ),
        decoration: BoxDecoration(
          color: AppColors.mediumGreen.withValues(
            alpha: 0.65,
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GALERI
            IconButton(
              onPressed:
                  _isTakingPicture ? null : _openGallery,
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
                size: 38,
              ),
            ),

            // TOMBOL AMBIL FOTO
            GestureDetector(
              onTap:
                  _isTakingPicture ? null : _takePicture,
              child: Container(
                width: 76,
                height: 76,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // FLASH
            IconButton(
              onPressed:
                  _isTakingPicture ? null : _toggleFlash,
              icon: Icon(
                _isFlashOn
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: Colors.white,
                size: 38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: Colors.white,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Tidak dapat membuka kamera.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // CAMERA PREVIEW
            if (_isCameraReady)
              _buildCameraPreview()
            else if (_errorMessage != null)
              _buildCameraError()
            else
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

            // HEADER
            _buildHeader(),

            // BOTTOM CONTROLS
            if (_isCameraReady)
              _buildBottomControls(),
          ],
        ),
      ),
    );
  }
}
