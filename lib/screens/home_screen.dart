import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:news/routes/app_pages.dart';
import 'package:news/screens/favorite_screen.dart';
import 'package:news/utils/app_colors.dart';
import 'package:news/widgets/category_chip.dart';
import 'package:news/widgets/loading_shimmer.dart';
import 'package:news/widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final NewsController controller = Get.find<NewsController>();

  final List<Widget> _pages = [const _HomeTab(), FavoritesScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.bidong,
        selectedItemColor: AppColors.error,
        unselectedItemColor: AppColors.divider,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: "Bookmarks",
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends GetView<NewsController> {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bidong,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bidong,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/LOGO.png',
             height: 40,
             ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => _showSearchDialog(context, controller),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            color: AppColors.background,
            height: 2,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(),
          _buildCategoryChips(controller),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) return const LoadingShimmer();
              if (controller.Error.isNotEmpty)
                return _buildErrorWidget(controller);
              if (controller.articles.isEmpty) return _buildEmptyWidget();

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return NewsCard(
                      article: article,
                      onTap: () =>
                          Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(NewsController controller) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.Categories.length,
        itemBuilder: (context, index) {
          final category = controller.Categories[index];
          return Obx(
            () => CategoryChip(
              label: category.capitalize ?? category,
              isSelected: controller.selectedCategory == category,
              onTap: () => controller.selectCategory(category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget() => const Center(child: Text(
    "No news available",
    style: TextStyle(
      color: AppColors.background,
    ),
    ));

  Widget _buildErrorWidget(NewsController controller) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        const Text('Something went wrong'),
        ElevatedButton(
          onPressed: controller.refreshNews,
          child: const Text('Retry'),
        ),
      ],
    ),
  );

  void _showSearchDialog(BuildContext context, NewsController controller) {
    final TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search news'),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Type a keyword...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
