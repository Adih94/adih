import 'package:flutter/material.dart';
import '../../animated_clouds.dart';
import '../../core/utils/landscape_layout.dart';
import '../../data/repositories/category_repository.dart';
import '../../widgets/app_header.dart';
import '../../widgets/category_icon_button.dart';
import '../category/category_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final categories = CategoryRepository.getCategories();

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
          child: Column(
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
                            double scale = index == _currentPage ? 1.0 : 0.88;
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
        ),
      ),
    );
  }
}
