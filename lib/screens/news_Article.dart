import 'package:flutter/material.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class ArticleDetailPage extends StatelessWidget {
  final Map<String, String> article; // Receive article data

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final heroImage = article['image'] ?? '';
    final title = article['title'] ?? '';
    final author = article['author'] ?? 'Author';
    final date = article['date'] ?? '';
    final description = article['description'] ?? 'No content available.';
    final authorAvatar = article['authorAvatar'] ??
        '[https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=80&q=60](https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=80&q=60)';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 15 / 14,
                child: Image.network(
                  heroImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    // Meta Row
                    Row(
                      children: [
                        Text(date,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        const SizedBox(width: 12),
                        _smallStat(Icons.thumb_up_alt_outlined, '1.2k'),
                        const SizedBox(width: 8),
                        _smallStat(Icons.visibility_outlined, '12k'),
                        const Spacer(),
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.favorite,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Body Text
                    Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    const SizedBox(height: 12),
                    // Tags (example static, can be dynamic later)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tagChip('#Sports'),
                        _tagChip('#Fashion'),
                        _tagChip('#Politics', filled: true),
                        _tagChip('#Health'),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Comments Header
                    Row(
                      children: [
                        const Text('Comments',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text('12.5k',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text('See All',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Add Comment Field
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(authorAvatar)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add a comment...',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.send, color: Colors.red)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

// Reusable widgets
  Widget _smallStat(IconData icon, String value) {
    return Row(children: [
      Icon(icon, size: 14, color: Colors.white),
      const SizedBox(width: 4),
      Text(value, style: TextStyle(color: Colors.white, fontSize: 12))
    ]);
  }

  Widget _tagChip(String label, {bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: filled ? Colors.red : Colors.grey[100],
          borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              color: filled ? Colors.white : Colors.black,
              fontSize: filled ? 14 : 12,
              fontWeight: FontWeight.bold)),
    );
  }
}
