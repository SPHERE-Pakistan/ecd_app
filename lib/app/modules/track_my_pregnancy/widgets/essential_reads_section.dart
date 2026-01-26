import 'package:babysafe/app/services/IntegrationServices/getArticles.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:babysafe/app/widgets/networkImageProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/track_my_pregnancy_controller.dart';

import '../views/article_page.dart';

class EssentialReadsSection extends StatefulWidget {
  final TrackMyPregnancyController controller;

  const EssentialReadsSection({Key? key, required this.controller}) : super(key: key);

  @override
  State<EssentialReadsSection> createState() => _EssentialReadsSectionState();
}

class _EssentialReadsSectionState extends State<EssentialReadsSection> {
  final ArticleService articleService = ArticleService.instance;

  @override
  void initState() {
    super.initState();
    // Fetch articles on init
    articleService.getAllBabyArticles(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final articles = articleService.babyArticleController.articles;

      if (articles.isEmpty) {
        return const SizedBox.shrink(); // No articles yet
      }

      // Split small and large articles (first 3 small, rest large)
      final smallArticles = articles.take(3).toList();
      final largeArticles = articles.skip(3).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "this_weeks_essential_reads".tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3D2929),
            ),
          ),
          const SizedBox(height: 16),

          // Small horizontal articles
          if (smallArticles.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: smallArticles.map((article) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 180,
                      child: _buildArticleCard(
                        context,
                        article.title ?? '',
                        subtitle: article.author,
                        article.imageUrl ?? '',
                        articleId: article.id.toString(),
                        aspectRatio: 1.2,
                        onTap: () => _openArticlePage(article),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Large vertical articles
          if (largeArticles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...largeArticles.map((article) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildArticleCard(
                context,
                article.title ?? '',
                article.imageUrl ?? '',
                articleId: article.id.toString(),
                subtitle: article.author ?? '',
                aspectRatio: 2.5,
                onTap: () => _openArticlePage(article),
              ),
            )),
          ],
        ],
      );
    });
  }

  void _openArticlePage(article) {
    print(article.imageUrl);
    Get.to(() => ArticlePage(
      title: article.title ?? '',
      imageAsset: article.imageUrl ?? '',
      content: article.content ?? '',
      articleId: article.id.toString(),
      createdAt: article.updatedAt,
      author: article.author,
    ));
  }

  Widget _buildArticleCard(
      BuildContext context,
      String title,
      String imageAsset, {
        String? articleId,
        String? subtitle,
        double aspectRatio = 1.5,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: NeoSafeColors.primaryPink.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: NeoSafeColors.primaryPink.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: NetworkImageProvider(
                  url: imageAsset,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3D2929),
                      height: 1.2,
                      fontSize: 14.5
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                    'By $subtitle',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B5555),
                      height: 1.3,
                      fontSize: 8
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _ArticleTag extends StatelessWidget {
  const _ArticleTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            NeoSafeColors.primaryPink.withOpacity(0.9),
            NeoSafeColors.lightPink.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: NeoSafeColors.primaryPink.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.article_outlined, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            'article'.tr,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
