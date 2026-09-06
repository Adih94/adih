import 'package:flutter/material.dart';
import '../../animated_clouds.dart';
import '../../core/utils/landscape_layout.dart';
import '../../data/repositories/category_repository.dart';
import '../../widgets/app_header.dart';
import '../../widgets/category_icon_button.dart';
import '../../widgets/cute_arrow_button.dart';
import '../category/category_screen.dart';
import '../lesson/letter_lesson_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  void _goToNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryRepository.getCategories();
    final screenHeight = LandscapeLayout.screenHeight(context);
    final arrowSize = (screenHeight * 0.24).clamp(56.0, 88.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppHeader(
        title: 'Belajar',
        showVipButton: false,
        onBack: () => Navigator.of(context).maybePop(),
        onVipTap: () {
          // TODO: navigasi ke halaman VIP Offer
        },
      ),
      body: AnimatedCloudSky(
        backgroundImageAsset: 'assets/images/bg_menu.png',
        child: Padding(
          padding: const EdgeInsets.only(top: 58),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cardSize =
                            LandscapeLayout.categoryCardSize(constraints);

                        return PageView.builder(
                          controller: _pageController,
                          itemCount: categories.length,
                          onPageChanged: (index) =>
                              setState(() => _currentPage = index),
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double scale =
                                    index == _currentPage ? 1.0 : 0.88;
                                if (_pageController.position.haveDimensions) {
                                  final page = _pageController.page ??
                                      _currentPage.toDouble();
                                  scale = (1 - (page - index).abs() * 0.12)
                                      .clamp(0.88, 1.0);
                                }
                                return Transform.scale(
                                  scale: scale,
                                  child: child,
                                );
                              },
                              child: Center(
                                child: CategoryIconButton(
                                  category: category,
                                  width: cardSize.width,
                                  height: cardSize.height,
                                  onTap: () {
                                    if (category.id == 'huruf') {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const LetterLessonScreen(),
                                        ),
                                      );
                                      return;
                                    }

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            CategoryScreen(category: category),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(categories.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isActive
                              ? categories[index].color
                              : Colors.white.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                ],
              ),

              // Tombol panah lucu di kiri, aktif jika bukan kategori pertama.
              Positioned(
                left: 6,
                child: CuteArrowButton(
                  direction: ArrowDirection.left,
                  size: arrowSize,
                  onTap: _currentPage > 0 ? _goToPrevious : null,
                ),
              ),

              // Tombol panah lucu di kanan, aktif jika bukan kategori terakhir.
              Positioned(
                right: 6,
                child: CuteArrowButton(
                  direction: ArrowDirection.right,
                  size: arrowSize,
                  onTap: _currentPage < categories.length - 1
                      ? _goToNext
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
