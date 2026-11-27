
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constant/app_colors.dart';
import '../models/plant_model.dart';

class PlantDetailPage extends StatelessWidget {
  final PlantModel plant;

  // Callback untuk menghubungkan fitur dari halaman lain.
  final VoidCallback? onScanDisease;
  final VoidCallback? onEditWatering;
  final VoidCallback? onHarvest;
  final VoidCallback? onEndTracking;

  const PlantDetailPage({
    super.key,
    required this.plant,
    this.onScanDisease,
    this.onEditWatering,
    this.onHarvest,
    this.onEndTracking,
  });

  static const String _icons = 'assets/icons';
  static const String _images = 'assets/images';

  // ============================================================
  // HELPER
  // ============================================================

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(value);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return value;
    }
  }

  String _getPlacement() {
    switch (plant.placement?.toLowerCase()) {
      case 'indoor':
        return 'Dalam Ruangan';
      case 'outdoor':
        return 'Luar Ruangan';
      default:
        return 'Belum tersedia';
    }
  }

  String _getHealthText() {
    if (plant.isHealthy == true) {
      return 'Sehat';
    }

    if (plant.isHealthy == false) {
      return 'Sakit';
    }

    return 'Belum diketahui';
  }

  Color _getHealthColor() {
    if (plant.isHealthy == true) {
      return AppColors.mediumGreen;
    }

    if (plant.isHealthy == false) {
      return AppColors.red;
    }

    return AppColors.grey;
  }

  int _getHarvestProgress() {
    final maturity = plant.maturity;

    if (maturity < 0) return 0;
    if (maturity > 100) return 100;

    return maturity;
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _svg(
    String path, {
    double size = 24,
    Color? color,
  }) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.mediumGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: _svg(
                  '$_icons/back.svg',
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Detail Tanaman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/logo_header.svg',
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PLANT INFORMATION
  // ============================================================

  Widget _buildPlantHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        0,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: plant.coverPhotoUrl != null &&
                      plant.coverPhotoUrl!.isNotEmpty
                  ? Image.network(
                      plant.coverPhotoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return _buildPhotoPlaceholder();
                      },
                    )
                  : _buildPhotoPlaceholder(),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            plant.label.isNotEmpty
                ? plant.label
                : plant.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            plant.commodityLabel,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildStatusChip(
                _getHealthText(),
                _getHealthColor(),
              ),
              _buildStatusChip(
                _getPlacement(),
                AppColors.mediumGreen,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Tanggal Tanam',
                  _formatDate(plant.plantedAt),
                  '$_icons/calendar.svg',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  'Usia Tanaman',
                  '${plant.ageDays} hari',
                  '$_icons/calendar.svg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: AppColors.lightGreen,
      child: const Center(
        child: Icon(
          Icons.eco_outlined,
          size: 60,
          color: AppColors.mediumGreen,
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String title,
    String value,
    String iconPath,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _svg(
                iconPath,
                size: 16,
                color: AppColors.mediumGreen,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE & CARD
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.darkGreen,
        ),
      ),
    );
  }

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        14,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // HARVEST
  // ============================================================

  Widget _buildHarvestCard() {
    final progress = _getHarvestProgress();

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Progres Panen'),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 10,
                    backgroundColor:
                        AppColors.lightGreen.withValues(
                      alpha: 0.5,
                    ),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      AppColors.mediumGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$progress%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mediumGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _svg(
                '$_images/harvest.svg',
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Estimasi Panen',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(plant.expectedHarvestMin),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WATERING
  // ============================================================

  Widget _buildWateringCard(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSectionTitle(
                  'Jadwal Penyiraman',
                ),
              ),
              TextButton(
                onPressed: onEditWatering ??
                    () {
                      _showMessage(
                        context,
                        'Pengaturan penyiraman belum tersedia.',
                      );
                    },
                child: const Text(
                  'Atur',
                  style: TextStyle(
                    color: AppColors.mediumGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _buildWateringInfo(
                  'Penyiraman Terakhir',
                  '-',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildWateringInfo(
                  'Penyiraman Berikutnya',
                  _formatDate(plant.nextWateringOn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWateringInfo(
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _svg(
            '$_images/watering.svg',
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptySection(
    String title,
    String imagePath,
    String message,
  ) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),

          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  imagePath,
                  height: 115,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEALTH HISTORY & DISEASE SCAN
  // ============================================================

  Widget _buildHealthSection(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Riwayat Kesehatan'),

          Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  '$_images/empty_health.svg',
                  height: 110,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Belum ada riwayat kesehatan tanaman.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onScanDisease ??
                  () {
                    _showMessage(
                      context,
                      'Halaman Pindai Penyakit belum terhubung di branch ini.',
                    );
                  },
              icon: _svg(
                '$_images/scan.svg',
                size: 20,
                color: Colors.white,
              ),
              label: const Text('Pindai Penyakit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ACTION BUTTONS
  // ============================================================

  Widget _buildActionButton({
    required String label,
    required String iconPath,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: _svg(
          iconPath,
          size: 20,
          color: Colors.white,
        ),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        4,
        20,
        20,
      ),
      child: Row(
        children: [
          _buildActionButton(
            label: 'Panen',
            iconPath: '$_images/harvest.svg',
            color: AppColors.orange,
            onPressed: onHarvest ??
                () {
                  _showMessage(
                    context,
                    'Fitur panen belum tersedia.',
                  );
                },
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            label: 'Akhiri Tracking',
            iconPath: '$_images/end_track.svg',
            color: AppColors.red,
            onPressed: onEndTracking ??
                () {
                  _showMessage(
                    context,
                    'Fitur akhiri tracking belum tersedia.',
                  );
                },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              children: [
                _buildPlantHero(),

                const SizedBox(height: 16),

                _buildHarvestCard(),

                _buildWateringCard(context),

                _buildEmptySection(
                  'Jurnal Tanaman',
                  '$_images/empty_journal.svg',
                  'Belum ada jurnal pertumbuhan tanaman.',
                ),

                _buildHealthSection(context),

                _buildEmptySection(
                  'Aktivitas Terbaru',
                  '$_images/empty_activity.svg',
                  'Belum ada aktivitas terbaru.',
                ),

                _buildBottomActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
