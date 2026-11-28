
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constant/app_colors.dart';

class DiseaseFeedbackPage extends StatefulWidget {
  final String diseaseName;
  final String status;

  const DiseaseFeedbackPage({
    super.key,
    required this.diseaseName,
    required this.status,
  });

  @override
  State<DiseaseFeedbackPage> createState() =>
      _DiseaseFeedbackPageState();
}

class _DiseaseFeedbackPageState
    extends State<DiseaseFeedbackPage> {
  int _rating = 0;

  final TextEditingController _commentController =
      TextEditingController();

  bool _isSubmitting = false;
  bool _showRatingWarning = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

void _submitFeedback() {
  if (_rating == 0) {
    setState(() {
      _showRatingWarning = true;
    });
    return;
  }

  final feedback = {
    'rating': _rating,
    'comment': _commentController.text.trim(),
    'disease_name': widget.diseaseName,
    'status': widget.status,
  };

  debugPrint('Dummy feedback: $feedback');

  Navigator.pop(context, true);
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
      child: SizedBox(
        height: 42,
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
            const Text(
              'Umpan Balik',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildStars() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final selected = index < _rating;

          return IconButton(
            onPressed: () {
              setState(() {
                _rating = index + 1;

                // Warning hilang setelah rating dipilih.
                _showRatingWarning = false;
              });
            },
            iconSize: 42,
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.star_rounded,
              color: selected
                  ? AppColors.mediumGreen
                  : AppColors.lightGreen,
            ),
          );
        }),
      ),

      // Warning ditampilkan tepat di bawah bintang.
      if (_showRatingWarning) ...[
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/warning_red.svg',
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 6),

            const Text(
              'Pilih rating terlebih dahulu.',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 11,
                color: AppColors.red,
              ),
            ),
          ],
        ),
      ],
    ],
  );
}

  Widget _buildCommentBox() {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/pencil.svg',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 12,
                color: AppColors.darkGreen,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: 'Tulis komentar (opsional)',
                hintStyle: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 11,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mediumGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Kirim Umpan Balik',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildBottomBackground() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: SvgPicture.asset(
          'assets/images/background_bottom.svg',
          width: double.infinity,
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dekorasi di belakang tombol Kirim.
          _buildBottomBackground(),

          Column(
            children: [
              _buildHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    30,
                    20,
                    16,
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo_header.svg',
                        width: 70,
                        height: 70,
                        colorFilter: const ColorFilter.mode(
                          AppColors.darkGreen,
                          BlendMode.srcIn,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Bagaimana hasil deteksi ini?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Masukanmu akan membantu kami '
                        'meningkatkan akurasi deteksi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildStars(),

                      const SizedBox(height: 28),

                      _buildCommentBox(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Tombol berada di atas background_bottom.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  18,
                ),
                child: Column(
                  children: [
                    _buildButton(),

                    const SizedBox(height: 12),

                    const Text(
                      'Umpan balikmu akan sangat berharga',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 10,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
