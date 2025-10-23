import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news/models/news_articles.dart';
import 'package:news/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailScreen extends StatelessWidget {
  final NewsArticles articles = Get.arguments as NewsArticles;

  NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // kalo kita pake customscrollview itu harus pake slivers, jadi kita bia custem sendiri
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, // buat di scroll tapi ga ilang
            flexibleSpace: FlexibleSpaceBar(
              background: articles.urlToImage != null
                  //membuat kompressati gambar -> size
                  ? CachedNetworkImage(
                      imageUrl: articles.urlToImage!,
                      // agar menutupi bagian semua dari app bar
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.divider,
                        child: Center(child: CircularProgressIndicator()),
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
                icon: Icon(Icons.share),
                onPressed:() => _shareArticle(), 
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
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(height: 8),
                        Text('Copy_Link')
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(height: 8),
                        Text('Open in Browser')
                      ],
                    ),
                  )
                ],
                )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //source an ddate
               Row(
                    children: [
                      if (articles.source?.name != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: Text(
                            articles.source!.name!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                      if (articles.publishedAt !=null) ...[
                        Text(
                          timeago.format(DateTime.parse(articles.publishedAt!)),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12
                          ),
                        ),
                      ]
                    ],
                  ),
                 SizedBox(height: 16),
                //title
                if(articles.title !=null) ...[
                  Text(
                    articles.title!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                //description
                if(articles.description !=null) ...[
                  Text(
                    articles.description!,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5
                    )
                  )
                ],
                SizedBox(height: 20),
                //content
                if(articles.content !=null) ...[
                  Text(
                    'content',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary
                    ),
                  ),
                  SizedBox(height:8),
                Text(
                  articles.content!,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.6
                  ),
                ),
                SizedBox(height: 24),
                ],
                //read full articles button
                if(articles.url !=null) ...[
                  SizedBox(width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openInBrowser,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )
                    ),
                    child: Text(
                      'read full articles',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ),
                  SizedBox(height: 32),
                ]
              ],
              ) ,
            ),
          )
        ],
      ),
    );
  }

  void _shareArticle() {
    if (articles.url !=null) {
      Share.share(
        '${articles.title ?? 'check out this news'}\n\n${articles.url!}',
        subject: articles.title
      );
    }
  }

  void _copyLink() {
    if (articles.url !=null ) {
      Clipboard.setData(ClipboardData(text: articles.url!));
      Get.snackbar(
        'Succes',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2)
      );
    }
  }

  void _openInBrowser() async {
    if (articles.url !=null) {
      // uri untuk parsing link agar di pahami sama aplikais lain
      final Uri url = Uri.parse(articles.url!);
      // proses menunggu apakah url valid dan bis di buka oleh browser
      if (await canLaunchUrl(url)) {
        //proses menunggu ketika url sudah valid dan sedang doi proses oleh browser, sampai datanya bisa di proses
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link',
          snackPosition: SnackPosition.BOTTOM
        );
      }
    }
  }
}
