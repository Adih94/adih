import 'package:flutter/material.dart';
import '../../animated_clouds.dart';
import '../../core/utils/landscape_layout.dart';
import '../../data/models/category_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/category_repository.dart';
import '../../widgets/app_header.dart';
import '../../widgets/lesson_card.dart';
import '../lesson/letter_lesson_screen.dart';
import '../lesson/number_lesson_screen.dart';
import '../lesson/reading_lesson_screen.dart';

/// Halaman ini yang tampilannya mirip screenshot: grid card lesson.
class CategoryScreen extends StatelessWidget {
  final CategoryModel category;

  const CategoryScreen({super.key, required this.category});

  void _onLessonTap(BuildContext context, LessonModel lesson, bool isUserVip) {
    final isLocked = lesson.vipTier != VipTier.none && !isUserVip;

    if (isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konten ini masih terkunci. Beli Paket VIP untuk membuka.'),
          duration: Duration(seconds: 2),
        ),
      );
      // TODO: bisa juga langsung navigasi ke VipOfferScreen di sini
      return;
    }

    // Lesson kategori "angka" dengan rentang angka -> buka NumberLessonScreen
    if (lesson.numberRangeStart != null && lesson.numberRangeEnd != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NumberLessonScreen(
            title: lesson.title,
            startNumber: lesson.numberRangeStart!,
            endNumber: lesson.numberRangeEnd!,
          ),
        ),
      );
      return;
    }

    // Lesson "Belajar Membaca" -> buka ReadingLessonScreen
    if (lesson.id == 'huruf_membaca') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReadingLessonScreen(
            title: lesson.title,
            words: CategoryRepository.getReadingWords(),
          ),
        ),
      );
      return;
    }

    if (lesson.id == 'huruf_mengenal') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LetterLessonScreen()),
      );
      return;
    }

    // Lesson lain yang belum ada halamannya (menyusul di tahap berikutnya)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modul ini sedang dalam pengembangan.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessons = CategoryRepository.getLessonsByCategory(category.id);
    final screenWidth = LandscapeLayout.screenWidth(context);
    final crossAxisCount = LandscapeLayout.lessonGridCrossAxisCount(screenWidth);
    final aspectRatio = LandscapeLayout.lessonCardAspectRatio(context);

    // TODO: ganti dengan status VIP asli dari local storage (tahap berikutnya)
    const bool isUserVip = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppHeader(
        title: category.title,
        showVipButton: false,
        // Kembali ke HomeScreen (halaman grid kategori)
        onBack: () => Navigator.of(context).pop(),
        onVipTap: () {
          // TODO: navigasi ke halaman VIP Offer
        },
      ),
      body: AnimatedCloudSky(
        backgroundImageAsset: 'assets/images/bg_menu.png',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 86, 16, 16),
          child: GridView.builder(
            itemCount: lessons.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return LessonCard(
                lesson: lesson,
                isUnlocked: isUserVip,
                onTap: () => _onLessonTap(context, lesson, isUserVip),
              );
            },
          ),
        ),
      ),
    );
  }
}
