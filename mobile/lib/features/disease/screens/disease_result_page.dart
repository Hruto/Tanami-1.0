
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constant/app_colors.dart';
import 'disease_feedback_page.dart';

class DiseaseResultPage extends StatelessWidget {
  final XFile image;
  final Map<String, dynamic> response;

  const DiseaseResultPage({
    super.key,
    required this.image,
    required this.response,
  });

  Map<String, dynamic> get _data =>
      response['data'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic> get _result =>
      _data['result'] as Map<String, dynamic>? ?? {};

  Map<String, dynamic>? get _top {
    final value = _result['top'];
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  String get _status => _data['status']?.toString() ?? 'unknown';

  double get _confidence {
    final value = _data['confidence'];
    if (value is num) return value.toDouble().clamp(0.0, 1.0);
    return 0;
  }

  String get _plantName {
    switch (_data['commodity_code']) {
      case 'mango':
        return 'Mangga';
      case 'citrus':
        return 'Jeruk';
      case 'tomato':
        return 'Tomat';
      default:
        return 'Tanaman';
    }
  }

  String get _dateText {
    final now = DateTime.now();

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String get _title {
    switch (_status) {
      case 'confident':
      case 'uncertain':
        return _top?['label']?.toString() ?? 'Penyakit';

      case 'unknown':
        return 'Penyakit Tidak Dikenal';

      case 'invalid_image':
        return 'Tidak Dapat Diidentifikasi';

      default:
        return 'Penyakit Tidak Dikenal';
    }
  }

  String get _scientificName {
    final detail =
        response['disease_detail'] as Map<String, dynamic>? ?? {};

    return detail['scientific_name']?.toString() ?? '';
  }

  bool get _isUnknown => _status == 'unknown';

  bool get _isInvalid => _status == 'invalid_image';

  bool get _isUncertain => _status == 'uncertain';

  Color get _confidenceColor {
    if (_isUncertain) return AppColors.orange;
    return AppColors.mediumGreen;
  }

  String get _confidenceLabel {
    switch (_status) {
      case 'confident':
        return 'Yakin';

      case 'uncertain':
        return 'Ragu';

      case 'unknown':
        return 'Tidak dikenal';

      case 'invalid_image':
        return 'Foto tidak valid';

      default:
        return 'Tidak dikenal';
    }
  }

  String get _warningTitle {
    if (_isInvalid) {
      return 'Foto tidak dapat dianalisis';
    }

    return 'Hindari Penggunaan Bahan Kimia Tanpa Kepastian';
  }

  String get _warningDescription {
    if (_isInvalid) {
      return 'Gambar terlalu buram, pencahayaan kurang, '
          'atau objek daun tidak terlihat jelas. '
          'Silakan ambil ulang foto dengan jarak 15–30 cm '
          'dan pencahayaan yang cukup.';
    }

    return 'Karena tingkat kecocokan masih rendah, '
        'sistem tidak merekomendasikan obat kimia tertentu. '
        'Lakukan pemeriksaan ulang atau konsultasikan '
        'foto ini kepada ahli agronomi.';
  }


Future<void> _goToFeedback(BuildContext context) async {
  final submitted = await Navigator.push<bool>(
    context,
    MaterialPageRoute<bool>(
      builder: (_) => DiseaseFeedbackPage(
        diseaseName: _title,
        status: _status,
      ),
    ),
  );

  if (!context.mounted || submitted != true) return;

  // Feedback selesai.
  // Kembali ke halaman sebelumnya, yaitu Detail Plant.
  Navigator.pop(context, true);
}

  Widget _buildHeader(BuildContext context) {
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
            'Hasil Pemindaian',
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

  

  Widget _buildCardBackground() {
    return IgnorePointer(
      child: SvgPicture.asset(
        'assets/images/background_card.svg',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }

  Widget _buildPlantImage() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Dekorasi daun hanya di area foto tanaman, bukan di setiap card.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 108,
            child: _buildCardBackground(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                Container(
                  width: 184,
                  height: 184,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: AppColors.grey,
                            size: 48,
                          );
                        },
                      ),
                      if (_isInvalid)
                        Container(
                          width: 144,
                          height: 144,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.42),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.priority_high_rounded,
                            size: 92,
                            color: AppColors.darkGreen.withValues(alpha: 0.85),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/leaf.svg',
                      width: 25,
                      height: 25,
                      colorFilter: const ColorFilter.mode(
                        AppColors.darkGreen,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        _isInvalid ? 'Tidak Dapat Diidentifikasi' : _plantName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: _isInvalid ? 19 : 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _dateText,
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseTitle() {
    if (_isUnknown) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/warning_green.svg',
            width: 23,
            height: 23,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              _title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGreen,
                height: 1.2,
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      _title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Alexandria',
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGreen,
        height: 1.2,
      ),
    );
  }

  Widget _buildConfidenceCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDiseaseTitle(),
          if (_scientificName.isNotEmpty && !_isUnknown && !_isInvalid) ...[
            const SizedBox(height: 3),
            Text(
              _scientificName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: AppColors.darkGreen,
                height: 1.25,
              ),
            ),
          ],
          const Divider(height: 24, thickness: 1),
          if (_isUnknown || _isInvalid)
            Text(
              _isInvalid
                  ? 'Foto tidak dapat dianalisis. Silakan ambil foto ulang.'
                  : 'Sistem tidak menemukan kecocokan dengan penyakit yang tersedia.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 12,
                height: 1.5,
                color: AppColors.grey,
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Tingkat Keyakinan AI',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGreen,
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _confidenceColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              _confidenceLabel,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isUncertain
                            ? 'Pola gejala pada daun tanaman terdeteksi, namun kecocokannya belum cukup kuat untuk memastikan diagnosis. Hasil ini bersifat indikatif dan perlu dicek ulang secara visual atau melalui pemindaian ulang.'
                            : 'Pola gejala pada tanaman memiliki kecocokan yang kuat.',
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 10,
                          height: 1.45,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 82,
                  height: 82,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 82,
                        height: 82,
                        child: CircularProgressIndicator(
                          value: _confidence,
                          strokeWidth: 10,
                          strokeCap: StrokeCap.round,
                          backgroundColor: AppColors.lightGreen,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _confidenceColor,
                          ),
                        ),
                      ),
                      Text(
                        '${(_confidence * 100).round()}%',
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/warning_red.svg',
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _warningTitle,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _warningDescription,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 10,
                    height: 1.5,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildAdviceCard() {
    final advice = response['advice'] as List<dynamic>? ?? [];

    if (advice.isEmpty) return const SizedBox.shrink();

    return _buildListCard(
      title: 'Penanganan',
      items: advice,
      numbered: true,
    );
  }

  Widget _buildRecommendationCard() {
    final recommendations =
        response['recommendations'] as List<dynamic>? ?? [];

    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildListCard(
      title: 'Rekomendasi Obat',
      items: recommendations,
      numbered: false,
    );
  }

  Widget _buildListCard({
    required String title,
    required List<dynamic> items,
    required bool numbered,
  }) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(items.length, (index) {
            final rawItem = items[index];
            final item = rawItem is Map<String, dynamic>
                ? rawItem
                : <String, dynamic>{};

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (numbered)
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.mediumGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    SvgPicture.asset(
                      'assets/icons/medicine.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.mediumGreen,
                        BlendMode.srcIn,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']?.toString() ??
                              item['name']?.toString() ??
                              '',
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkGreen,
                            height: 1.25,
                          ),
                        ),
                        if ((item['description']?.toString() ?? '').isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item['description'].toString(),
                            style: const TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 10,
                              height: 1.3,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
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
            borderRadius: BorderRadius.circular(18),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background ikut bergerak bersama konten saat halaman di-scroll.
                  Positioned(
                    top: 285,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: SvgPicture.asset(
                        'assets/images/background.svg',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPlantImage(),
                        const SizedBox(height: 18),
                        if (!_isInvalid) _buildConfidenceCard(),
                        SizedBox(height: _isInvalid ? 22 : 18),
                        if (_isUnknown || _isInvalid)
                          _buildWarningCard()
                        else ...[
                          if (_isUncertain) ...[
                            _buildWarningCard(),
                            const SizedBox(height: 14),
                          ],
                          _buildAdviceCard(),
                          const SizedBox(height: 14),
                          _buildRecommendationCard(),
                        ],
                        const SizedBox(height: 20),

                        // Tombol menjadi bagian dari konten scroll,
                        // bukan widget yang menempel di bawah layar.
                        if (_isInvalid || _isUnknown) ...[
                          _buildBottomButton(
                            text: 'Foto Ulang',
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (!_isInvalid)
                          _buildBottomButton(
                            text: 'Kembali ke Tanaman',
                            primary: true,
                            onPressed: () => _goToFeedback(context),
                          ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hasil AI merupakan rekomendasi awal, bukan diagnosis ahli.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 9,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
