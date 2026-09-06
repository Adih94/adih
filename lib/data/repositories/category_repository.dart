import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/lesson_model.dart';
import '../models/reading_word_model.dart';

/// Data masih hardcode (dummy) dulu, belum dari database/API.
/// Nanti gampang diganti tinggal ubah isi fungsi-fungsi di bawah ini.
class CategoryRepository {
  static List<CategoryModel> getCategories() {
    return const [
      CategoryModel(
        id: 'huruf',
        title: 'Huruf',
        icon: Icons.abc,
        color: AppColors.primaryYellow,
        imageAsset: 'assets/images/category_huruf.png',
      ),
      CategoryModel(
        id: 'piano',
        title: 'Piano',
        icon: Icons.piano,
        color: AppColors.primaryPink,
        imageAsset: 'assets/images/category_piano.png',
      ),
      CategoryModel(
        id: 'suku_vokal',
        title: 'Suku Kata & Huruf Vokal',
        icon: Icons.menu_book,
        color: AppColors.primaryPurple,
        imageAsset: 'assets/images/category_suku_vokal.png',
      ),
      CategoryModel(
        id: 'suku_sengau',
        title: 'Suku Kata & Kata Sengau',
        icon: Icons.pets,
        color: AppColors.primaryGreen,
        imageAsset: 'assets/images/category_suku_sengau.png',
      ),
      CategoryModel(
        id: 'suku_ganda',
        title: 'Suku Kata dengan Double Konsonan',
        icon: Icons.spa,
        color: AppColors.primaryOrange,
        imageAsset: 'assets/images/category_suku_ganda.png',
      ),
      CategoryModel(
        id: 'menulis',
        title: 'Menulis',
        icon: Icons.edit,
        color: AppColors.primaryBlue,
        imageAsset: 'assets/images/category_menulis.png',
      ),
      CategoryModel(
        id: 'mewarnai',
        title: 'Mewarnai',
        icon: Icons.color_lens,
        color: AppColors.primaryTeal,
        imageAsset: 'assets/images/category_mewarnai.png',
      ),
    ];
  }

  static List<LessonModel> getLessonsByCategory(String categoryId) {
    switch (categoryId) {
      case 'angka':
        return const [
          LessonModel(
            id: 'angka_30_39',
            categoryId: 'angka',
            title: 'Belajar Angka 30 sampai 39',
            backgroundColor: AppColors.primaryPink,
            numberRangeStart: 30,
            numberRangeEnd: 39,
          ),
          LessonModel(
            id: 'angka_ratusan',
            categoryId: 'angka',
            title: 'Belajar Angka Ratusan',
            backgroundColor: AppColors.primaryPurple,
            vipTier: VipTier.vip,
          ),
          LessonModel(
            id: 'angka_menulis',
            categoryId: 'angka',
            title: 'Belajar Menulis Angka',
            backgroundColor: AppColors.primaryOrange,
            fileSizeLabel: '808 KB',
            vipTier: VipTier.vip,
          ),
          LessonModel(
            id: 'angka_40_50',
            categoryId: 'angka',
            title: 'Belajar Angka 40 sampai 50',
            backgroundColor: AppColors.primaryOrange,
            numberRangeStart: 40,
            numberRangeEnd: 50,
          ),
          LessonModel(
            id: 'angka_ribuan',
            categoryId: 'angka',
            title: 'Belajar Angka Ribuan',
            backgroundColor: AppColors.primaryRed,
            vipTier: VipTier.vip,
          ),
          LessonModel(
            id: 'angka_jari',
            categoryId: 'angka',
            title: 'Belajar Jari Angka',
            backgroundColor: AppColors.primaryPink,
            fileSizeLabel: '510 KB',
            vipTier: VipTier.vip,
          ),
        ];
      case 'piano':
        // Piano dibuka langsung dari HomeScreen, tanpa daftar lesson.
        return const [];
      case 'menulis':
        return const [
          LessonModel(
            id: 'menulis_huruf',
            categoryId: 'menulis',
            title: 'Belajar Menulis Huruf',
            backgroundColor: AppColors.primaryBlue,
            fileSizeLabel: '299 KB',
          ),
          LessonModel(
            id: 'menulis_angka',
            categoryId: 'menulis',
            title: 'Belajar Menulis Angka',
            backgroundColor: AppColors.primaryOrange,
            fileSizeLabel: '254 KB',
            vipTier: VipTier.vip,
          ),
        ];
      case 'suku_vokal':
        return const [
          LessonModel(
            id: 'vokal_mengenal',
            categoryId: 'suku_vokal',
            title: 'Mengenal Huruf Vokal',
            backgroundColor: AppColors.primaryPurple,
          ),
          LessonModel(
            id: 'vokal_suku_kata',
            categoryId: 'suku_vokal',
            title: 'Suku Kata Vokal',
            backgroundColor: AppColors.primaryPink,
          ),
        ];
      case 'suku_sengau':
        return const [
          LessonModel(
            id: 'sengau_ng_ny_n',
            categoryId: 'suku_sengau',
            title: 'Belajar ng, ny, n',
            backgroundColor: AppColors.primaryGreen,
          ),
          LessonModel(
            id: 'sengau_kata',
            categoryId: 'suku_sengau',
            title: 'Kata Sengau',
            backgroundColor: AppColors.primaryBlue,
          ),
        ];
      case 'suku_ganda':
        return const [
          LessonModel(
            id: 'ganda_ll_tt_kk',
            categoryId: 'suku_ganda',
            title: 'Belajar ll, tt, kk',
            backgroundColor: AppColors.primaryOrange,
          ),
          LessonModel(
            id: 'ganda_kata',
            categoryId: 'suku_ganda',
            title: 'Kata Double Konsonan',
            backgroundColor: AppColors.primaryRed,
          ),
        ];
      case 'mewarnai':
        return const [
          LessonModel(
            id: 'mewarnai_hewan',
            categoryId: 'mewarnai',
            title: 'Mewarnai Hewan',
            backgroundColor: AppColors.primaryTeal,
          ),
          LessonModel(
            id: 'mewarnai_buah',
            categoryId: 'mewarnai',
            title: 'Mewarnai Buah',
            backgroundColor: AppColors.primaryPink,
          ),
        ];
      case 'huruf':
      default:
        return const [
          LessonModel(
            id: 'huruf_mengenal',
            categoryId: 'huruf',
            title: 'Mengenal Huruf A-Z',
            backgroundColor: AppColors.primaryYellow,
            thumbnailAsset: 'assets/images/bg_letter_lesson.png',
            showAnimatedLetters: true,
          ),
          LessonModel(
            id: 'huruf_membaca',
            categoryId: 'huruf',
            title: 'Belajar Membaca',
            backgroundColor: AppColors.primaryGreen,
          ),
        ];
    }
  }

  /// Data contoh kata untuk modul "Belajar Membaca".
  /// Nanti gampang ditambah tinggal masukkan item baru ke list ini.
  static List<ReadingWordModel> getReadingWords() {
    return const [
      ReadingWordModel(
        word: 'bola',
        syllables: ['bo', 'la'],
        icon: Icons.sports_soccer,
      ),
      ReadingWordModel(
        word: 'tali',
        syllables: ['ta', 'li'],
        icon: Icons.link,
      ),
      ReadingWordModel(
        word: 'mata',
        syllables: ['ma', 'ta'],
        icon: Icons.remove_red_eye,
      ),
      ReadingWordModel(
        word: 'buku',
        syllables: ['bu', 'ku'],
        icon: Icons.menu_book,
      ),
      ReadingWordModel(
        word: 'susu',
        syllables: ['su', 'su'],
        icon: Icons.local_drink,
      ),
    ];
  }
}
