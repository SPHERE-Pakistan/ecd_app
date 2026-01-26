import 'package:babysafe/app/widgets/networkImageProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babysafe/app/utils/neo_safe_theme.dart';
import 'package:intl/intl.dart'; // <- Import intl

class ArticlePage extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String content;
  final String? subtitle;
  final String? articleId;
  final String? createdAt;
  final String? author;

  const ArticlePage({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.content,
    this.subtitle,
    this.articleId,
    this.createdAt,
    this.author
  }) : super(key: key);

  // Convert backend date to Pakistan Standard Time (Asia/Karachi) and format it
  String formatDateToPakistan(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      // Parse backend date string
      DateTime utcDate = DateTime.parse(dateString).toUtc();
      // Convert to Pakistan Standard Time (UTC+5)
      DateTime pakTime = utcDate.add(const Duration(hours: 5));
      // Format date nicely: Example -> 26 Jan 2026, 03:45 PM
      return DateFormat('dd MMM yyyy, hh:mm a').format(pakTime);
    } catch (e) {
      print("Error parsing date: $e");
      return dateString; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDateToPakistan(createdAt);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: NeoSafeColors.primaryPink),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  NeoSafeColors.primaryPink.withOpacity(0.9),
                  NeoSafeColors.roseAccent.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: NeoSafeColors.primaryPink.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.article_outlined,
                  color: Colors.white,
                  size: 14,
                ),
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
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: NeoSafeGradients.backgroundGradient,
        ),
        child: CustomScrollView(
          slivers: [
            // Hero Image Section
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: NetworkImageProvider(
                      url: imageAsset,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      errorWidget: Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            subtitle!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: NeoSafeColors.primaryPink.withOpacity(0.08),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: NeoSafeColors.primaryPink.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: NeoSafeColors.primaryText,
                          height: 1.6,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              NeoSafeColors.primaryPink.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'thanks_for_reading'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: NeoSafeColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if(author != null) Text(
                        'Brought to you by $author',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:Colors.black
                        ),
                      ),
                      const SizedBox(height: 2),
                      if(formattedDate.isNotEmpty) Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeoSafeColors.secondaryText,
                          fontSize: 9
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
