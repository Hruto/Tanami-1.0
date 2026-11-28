
class DiseaseMockData {
  // Ubah status ini untuk mencoba tampilan Result Page.
  // confident | uncertain | unknown | invalid_image
  static const String testStatus = 'invalidImage';

  static Map<String, dynamic> responseFor([
    String status = testStatus,
  ]) {
    switch (status) {
      case 'confident':
        return _confident();

      case 'uncertain':
        return _uncertain();

      case 'unknown':
        return _unknown();

      case 'invalid_image':
        return _invalidImage();

      default:
        return _unknown();
    }
  }

  // =========================================================
  // CONFIDENT
  // =========================================================

  static Map<String, dynamic> _confident() {
    return {
      'data': {
        'type': 'disease',
        'status': 'confident',
        'model_version': 'disease-mango-v0.1.0',
        'commodity_code': 'mango',
        'confidence': 0.87,
        'quality': {
          'blur': 'ok',
          'brightness': 'ok',
        },
        'result': {
          'top': {
            'disease_code': 'mango_anthracnose',
            'label': 'Antraknosa',
            'cause_category': 'fungus',
            'confidence': 0.87,
          },
          'alternatives': [
            {
              'disease_code': 'mango_powdery_mildew',
              'label': 'Embun Tepung',
              'cause_category': 'fungus',
              'confidence': 0.08,
            },
          ],
          'is_healthy': false,
          'severity': 'moderate',
        },
      },

      'disease_detail': {
        'disease_code': 'mango_anthracnose',
        'name': 'Antraknosa',
        'scientific_name': 'Colletotrichum gloeosporioides',
        'cause_category': 'fungus',
        'description':
            'Penyakit tanaman yang dapat menyebabkan '
            'bercak gelap pada daun dan bagian tanaman lainnya.',
      },

      'advice': [
        {
          'title': 'Sanitasi & Pemangkasan Bagian Terinfeksi',
          'description':
              'Pangkas dan singkirkan bagian tanaman '
              'yang menunjukkan gejala terinfeksi.',
        },
        {
          'title': 'Pengaturan Kelembapan & Sirkulasi Udara',
          'description':
              'Atur jarak tanam dan sirkulasi udara '
              'agar tanaman tidak terlalu lembap.',
        },
        {
          'title': 'Manajemen Penyiraman',
          'description':
              'Hindari penyiraman langsung ke bagian daun '
              'dan utamakan penyiraman pada pagi hari.',
        },
      ],

      'recommendations': [
        {
          'name': 'Mankozeb',
          'description':
              'Contoh rekomendasi fungisida yang perlu '
              'disesuaikan dengan label produk dan '
              'ketentuan penggunaan setempat.',
        },
        {
          'name': 'Azoksistrobin',
          'description':
              'Contoh bahan aktif fungisida yang dapat '
              'dipertimbangkan berdasarkan diagnosis '
              'dan rekomendasi ahli.',
        },
        {
          'name': 'Tembaga hidroksida',
          'description':
              'Contoh bahan aktif fungisida berbasis '
              'tembaga yang perlu digunakan sesuai '
              'label produk.',
        },
      ],
    };
  }

  // =========================================================
  // UNCERTAIN
  // =========================================================

  static Map<String, dynamic> _uncertain() {
    return {
      'data': {
        'type': 'disease',
        'status': 'uncertain',
        'model_version': 'disease-mango-v0.1.0',
        'commodity_code': 'mango',
        'confidence': 0.62,
        'quality': {
          'blur': 'ok',
          'brightness': 'ok',
        },
        'result': {
          'top': {
            'disease_code': 'mango_anthracnose',
            'label': 'Antraknosa',
            'cause_category': 'fungus',
            'confidence': 0.62,
          },
          'alternatives': [
            {
              'disease_code': 'mango_powdery_mildew',
              'label': 'Embun Tepung',
              'cause_category': 'fungus',
              'confidence': 0.28,
            },
          ],
          'is_healthy': false,
          'severity': null,
        },
      },

      'disease_detail': {
        'disease_code': 'mango_anthracnose',
        'name': 'Antraknosa',
        'scientific_name': 'Colletotrichum gloeosporioides',
        'cause_category': 'fungus',
        'description':
            'Hasil prediksi memiliki kecocokan sedang '
            'dan masih memerlukan pemeriksaan ulang.',
      },

      'advice': [
        {
          'title': 'Periksa Kondisi Daun',
          'description':
              'Amati pola bercak dan perubahan warna '
              'daun secara berkala.',
        },
        {
          'title': 'Pantau Perkembangan',
          'description':
              'Ambil foto ulang jika gejala pada daun '
              'mengalami perubahan.',
        },
        {
          'title': 'Periksa Tanaman Secara Menyeluruh',
          'description':
              'Bandingkan gejala pada beberapa bagian '
              'tanaman untuk membantu memastikan kondisi.',
        },
      ],

      // Status uncertain tidak menampilkan rekomendasi obat.
      'recommendations': [],
    };
  }

  // =========================================================
  // UNKNOWN
  // =========================================================

  static Map<String, dynamic> _unknown() {
    return {
      'data': {
        'type': 'disease',
        'status': 'unknown',
        'model_version': 'disease-mango-v0.1.0',
        'commodity_code': 'mango',
        'confidence': 0.31,
        'quality': {
          'blur': 'ok',
          'brightness': 'ok',
        },
        'result': {
          'top': null,
          'alternatives': [],
          'is_healthy': null,
          'severity': null,
        },
      },

      'disease_detail': null,

      'advice': [],

      'recommendations': [],
    };
  }

  // =========================================================
  // INVALID IMAGE
  // =========================================================

  static Map<String, dynamic> _invalidImage() {
    return {
      'data': {
        'type': 'disease',
        'status': 'invalid_image',
        'model_version': 'disease-mango-v0.1.0',
        'commodity_code': 'mango',

        // Confidence dibuat 0 karena foto tidak berhasil
        // dianalisis. UI sebaiknya tidak menampilkan
        // confidence untuk status invalid_image.
        'confidence': 0.0,

        'quality': {
          'blur': 'bad',
          'brightness': 'ok',
        },

        'result': {
          'top': null,
          'alternatives': [],
          'is_healthy': null,
          'severity': null,
        },
      },

      'disease_detail': null,

      'advice': [],

      'recommendations': [],
    };
  }
}
