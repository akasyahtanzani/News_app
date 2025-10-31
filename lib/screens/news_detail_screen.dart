import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news/models/news_articles.dart';
import 'package:news/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news/controllers/favorite_controller.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsArticles articles = Get.arguments as NewsArticles;
  final FavoriteController favoriteController = Get.put(FavoriteController());

  NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool isFavorite = false; // buat status favorit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bidong,
      // kalo kita pake customscrollview itu harus pake slivers, jadi kita bia custem sendiri
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, // buat di scroll tapi ga ilang
            flexibleSpace: FlexibleSpaceBar(
              background: widget.articles.urlToImage != null
                  //membuat kompressati gambar -> size
                  ? CachedNetworkImage(
                      imageUrl: widget.articles.urlToImage!,
                      // agar menutupi bagian semua dari app bar
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.divider,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.divider,
                        // biar kalo error yang muncul bukan code, jadi user gaboleh tau
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  //statement yang akan di jalankan ketika server tidak memiliki gambar
                  // atau => image == null
                  : Container(
                      color: AppColors.divider,
                      child: Icon(
                        Icons.newspaper,
                        size: 50,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  widget.favoriteController.toggleFavorite(widget.articles);
                  final isFav = widget.favoriteController.isFavorite(
                    widget.articles,
                  );

                  setState(() {
                    isFavorite = isFav;
                  });

                  Get.snackbar(
                    isFav
                        ? 'Added to Favorites ❤️'
                        : 'Removed from Favorites 🤍',
                    widget.articles.title ?? '',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareArticle(),
              ),
              PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                    case 'open_browser':
                      _openInBrowser();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //source and date
                  Row(
                    children: [
                      if (widget.articles.source?.name != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.articles.source!.name!,
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (widget.articles.publishedAt != null) ...[
                        Text(
                          timeago.format(
                            DateTime.parse(widget.articles.publishedAt!),
                          ),
                          style: TextStyle(
                            color: AppColors.background,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  //title
                  if (widget.articles.title != null) ...[
                    Text(
                      widget.articles.title!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  //description
                  if (widget.articles.description != null) ...[
                    Text(
                      widget.articles.description!,
                      style: const TextStyle(
                        color: AppColors.background,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  //content
                  if (widget.articles.content != null) ...[
                    const Text(
                      'Content',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.articles.content!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.background,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  //read full articles button
                  if (widget.articles.url != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _openInBrowser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Read Full Article',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.open_in_new,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareArticle() {
    if (widget.articles.url != null) {
      Share.share(
        '${widget.articles.title ?? 'Check out this news!'}\n\n${widget.articles.url!}',
        subject: widget.articles.title,
      );
    }
  }

  void _copyLink() {
    if (widget.articles.url != null) {
      Clipboard.setData(ClipboardData(text: widget.articles.url!));
      Get.snackbar(
        'Success',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _openInBrowser() async {
    if (widget.articles.url != null) {
      final Uri url = Uri.parse(widget.articles.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
