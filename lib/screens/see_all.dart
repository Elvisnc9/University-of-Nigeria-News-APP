import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:student_application/screens/home_screen.dart';
import 'package:student_application/screens/news_Article.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class ViewAll extends StatefulWidget {
   ViewAll({super.key});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final latest = [
    {
      'title': 'Instagram working on Exclusive Stories for subscribers',
      'date': '16 Jan 2023',
      'author': 'John Doe',
      'image':
          'https://images.unsplash.com/photo-1648023199223-25d3622bcb13?q=80&w=870&auto=format&fit=crop',
      'description':
      'We are happy to announce the immediate of the Express to our active VCL Subscribers.'
          ' The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
            'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'

          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
    },
    {
      'title':
          'CWG 2022: "Best performance", says Bindyarani Devi after clinching Silver medal',
      'date': '10 Jan 2023',
      'author': 'Sports Desk',
      'image':
          'https://images.unsplash.com/photo-1707008797390-38f13ea40163?q=80&w=464&auto=format&fit=crop',
      'description':
          'We are happy to announce the immediate of the Express to our active VCL Subscribers.'
          ' The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
            'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'

          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
    },

    {
      'title':
          'CWG 2022: "Best performance", says Bindyarani Devi after clinching Silver medal',
      'date': '10 Jan 2023',
      'author': 'Sports Desk',
      'image':
          'https://images.unsplash.com/photo-1554457606-ed16c39db884?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'description':
          'We are happy to announce the immediate of the Express to our active VCL Subscribers.'
          ' The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
            'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'

    },

    {
      'title': 'Instagram working on Exclusive Stories for subscribers',
      'date': '16 Jan 2023',
      'author': 'John Doe',
      'image':
          'https://images.unsplash.com/photo-1648023199223-25d3622bcb13?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'description':
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
    },

    {
      'title':
          'CWG 2022: "Best performance", says Bindyarani Devi after clinching Silver medal',
      'date': '10 Jan 2023',
      'author': 'Sports Desk',
      'image':
          'https://images.unsplash.com/photo-1707008797390-38f13ea40163?q=80&w=464&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'description':
          'We are happy to announce the immediate of the Express to our active VCL Subscribers. The most significant upgrade to this product library since its initial release over 7 years ago.'
    }, //Add more articles...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            //  buildSearchBox(),

              _sectionHeader('Latest News', actionText: 'See All'),
            const SizedBox(height: 12),
            ...latest.map(_latestCard).toList(),
             
          ],
        ),
      ),
    );
  }

  
  Widget _sectionHeader(String title, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        if (actionText != null && actionText.isNotEmpty)
          Text(actionText,
              style: const TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _latestCard(Map<String, String> item) {
    return InkWell(
      onTap: () => Navigator.push(context as BuildContext,
          MaterialPageRoute(builder: (_) => ArticleDetailPage(article: item))),
      child: Card(
        color: Colors.white10,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item['image']!,
                    width: 35.w, height: 15.h, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(item['date'] ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(item['title']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(item[
                                    'authorAvatar'] ??
                                'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=80&q=60')),
                        const SizedBox(width: 8),
                        Text(item['author'] ?? 'Author',
                            style: TextStyle(
                                color: Colors.grey[300], fontSize: 12)),
                        const Spacer(),
                        Icon(Icons.favorite_border,
                            color: Colors.pinkAccent, size: 18),
                        const SizedBox(width: 8),
                        Icon(Icons.bookmark_border,
                            color: Colors.grey[500], size: 18),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  
}