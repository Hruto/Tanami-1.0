import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constant/app_colors.dart';
import '../../disease/screens/disease_camera_page.dart';
import '../models/plant_model.dart';

import 'package:camera/camera.dart';

import 'camera_capture_page.dart';
import '../../disease/screens/disease_preview_page.dart';

class PlantDetailPage extends StatelessWidget {
  final PlantModel plant;

  const PlantDetailPage({
    super.key,
    required this.plant,
  });

  static const String _icons = 'assets/icons';
  static const String _images = 'assets/images';
  Future<void> _startDiseaseScan(BuildContext context) async {
    final XFile? image = await Navigator.push<XFile>(
      context,
      MaterialPageRoute<XFile>(
        builder: (_) => const CameraCapturePage(),
      ),
    );

    if (!context.mounted || image == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiseasePreviewPage(image: image),
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '-';

    try {
      final date = DateTime.parse(value);
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return value;
    }
  }

  String _placementText() {
    switch (plant.placement?.toLowerCase()) {
      case 'indoor':
        return 'Indoor';
      case 'outdoor':
        return 'Outdoor';
      default:
        return 'Lokasi belum diatur';
    }
  }

  String _healthText() {
    if (plant.isHealthy == true) return 'Sehat';
    if (plant.isHealthy == false) return 'Sakit';
    return 'Belum diketahui';
  }

  Color _healthColor() {
    if (plant.isHealthy == true) return AppColors.mediumGreen;
    if (plant.isHealthy == false) return AppColors.red;
    return AppColors.grey;
  }

  int _harvestProgress() {
    final value = plant.maturity;
    if (value < 0) return 0;
    if (value > 100) return 100;
    return value;
  }

  Widget _svg(String path, {double size = 24, Color? color}) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 134,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.mediumGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 20,
              top: 18,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: _svg('$_icons/back.svg', size: 25, color: Colors.white),
              ),
            ),
            Positioned(
              top: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo_header.svg',
                    height: 28,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Detail Tanaman',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
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

  Widget _plantHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 210,
            width: double.infinity,
            child: plant.coverPhotoUrl != null &&
                    plant.coverPhotoUrl!.isNotEmpty
                ? Image.network(
                    plant.coverPhotoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _photoPlaceholder(),
                  )
                : _photoPlaceholder(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        plant.label.isNotEmpty ? plant.label : plant.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _statusChip(_healthText(), _healthColor()),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plant.commodityLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                    _svg('$_icons/placement.svg', size: 15, color: AppColors.grey),
                    const SizedBox(width: 5),
                    Text(
                      _placementText(),
                      style: const TextStyle(fontSize: 11, color: AppColors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                _detailInfoRow('Tanggal Tanam', _formatDate(plant.plantedAt)),
                const SizedBox(height: 4),
                _detailInfoRow('Usia Tanaman', '${plant.ageDays} Hari'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      color: AppColors.lightGreen,
      child: const Center(
        child: Icon(Icons.eco_outlined, size: 62, color: AppColors.mediumGreen),
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 54),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _detailInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child, double? minHeight}) {
    return Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight),
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
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

  Widget _harvestCard() {
    final progress = _harvestProgress();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Progres Menuju Panen'),
          const Text(
            'Estimasi tanggal panen:',
            style: TextStyle(fontSize: 11, color: AppColors.grey),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(plant.expectedHarvestMin),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.mediumGreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Pantau tanaman',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              backgroundColor: AppColors.lightGreen,
              valueColor: const AlwaysStoppedAnimation(AppColors.mediumGreen),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$progress% progress',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Terus pantau dan rawat tanamanmu agar siap menghasilkan panen terbaik!',
            style: TextStyle(fontSize: 11, color: AppColors.grey, height: 1.25),
          ),
        ],
      ),
    );
  }

  Widget _wateringCard(BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _sectionTitle('Jadwal Penyiraman')),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.mediumGreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  plant.irrigationSchedule?.toString() ?? 'Jadwal',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _wateringInfo(
                  'Terakhir disiram',
                  '-',
                  'assets/images/watering_can.svg',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _wateringInfo(
                  'Penyiraman berikutnya',
                  _formatDate(plant.nextWateringOn),
                  'assets/images/watering.svg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _message(context, 'Pengaturan jadwal penyiraman akan dihubungkan.'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Edit Jadwal Penyiraman',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wateringInfo(String title, String value, String image) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _svg(image, size: 18, color: AppColors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 9, color: AppColors.grey)),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard({
    required String title,
    required String imagePath,
    required String message,
    required double minHeight,
    Widget? action,
    double imageHeight = 145,
  }) {
    return _card(
      minHeight: minHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title),
          SizedBox(
            height: 205,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    imagePath,
                    height: imageHeight,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Mulai tambahkan aktivitas pertumbuhan tanamanmu untuk melihatnya di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 12),
            action,
          ],
        ],
      ),
    );
  }

  Widget _scanButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
      onPressed: () => _startDiseaseScan(context),
        icon: _svg('$_images/scan.svg', size: 20, color: Colors.white),
        label: const Text(
          'Pindai Penyakit',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mediumGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _healthCard(BuildContext context) {
    return _emptyCard(
      title: 'Riwayat Kesehatan Tanaman',
      imagePath: '$_images/empty_health.svg',
      message: 'Belum ada riwayat kesehatan tanaman',
      minHeight: 335,
      imageHeight: 145,
      action: _scanButton(context),
    );
  }

  Widget _activityCard() {
    return _emptyCard(
      title: 'Aktivitas Terakhir',
      imagePath: '$_images/empty_activity.svg',
      message: 'Belum ada aktivitas',
      minHeight: 260,
      imageHeight: 130,
    );
  }

  Widget _journalCard(BuildContext context) {
    return _emptyCard(
      title: 'Jurnal Tanaman',
      imagePath: '$_images/empty_journal.svg',
      message: 'Belum ada riwayat pertumbuhan',
      minHeight: 335,
      imageHeight: 145,
      action: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _message(context, 'Fitur unggah foto jurnal akan dihubungkan.'),
          icon: _svg('$_images/camera.svg', size: 20, color: Colors.white),
          label: const Text(
            'Unggah Foto',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mediumGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 18),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _message(context, 'Fitur panen akan dihubungkan.'),
              icon: _svg('$_images/harvest.svg', size: 20, color: Colors.white),
              label: const Text('Panen', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mediumGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _message(context, 'Fitur akhiri tracking akan dihubungkan.'),
              icon: _svg('$_images/end_track.svg', size: 20, color: AppColors.red),
              label: const Text(
                'Akhiri Tracking',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorBackground,
                foregroundColor: AppColors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    const items = [
      (Icons.home_outlined, 'Beranda'),
      (Icons.park_outlined, 'Kebun'),
      (Icons.history, 'Riwayat'),
      (Icons.forum_outlined, 'Forum'),
      (Icons.person_outline, 'Profil'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.$1,
                size: 25,
                color: selected ? AppColors.mediumGreen : AppColors.grey,
              ),
              const SizedBox(height: 3),
              Text(
                item.$2,
                style: TextStyle(
                  fontSize: 9,
                  color: selected ? AppColors.mediumGreen : AppColors.grey,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0, bottom: 8),
              children: [
                _plantHero(),
                _harvestCard(),
                _wateringCard(context),
                _journalCard(context),
                _healthCard(context),
                _activityCard(),
                _bottomActions(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: _bottomNavigation(),
      ),
    );
  }
}
