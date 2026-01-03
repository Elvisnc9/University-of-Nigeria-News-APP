import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:student_application/screens/news_Article.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  final PageController _pageController = PageController(viewportFraction: 0.92);
  Timer? _autoScrollTimer;
  final ValueNotifier<int> _currentActionPage = ValueNotifier<int>(0);
  
  // 🔍 SEARCH CONTROLLER
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> trending = [
    <String, String>{
      'title': 'Examinations Approaching and New Strategies adopted',
      'tag': 'Academics',
      'image':
      'https://images.unsplash.com/photo-1627423893729-3a79f48ff473?q=80&w=869&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'description' : 'UNN 2025/2026 First Semester Examinations Begin in 10 Days – New Anti-Malpractice Strategies, CBT Rollout & “Zero Tolerance” Rules Unveiled!Nsukka, December 2, 2025 – The countdown is official: First Semester examinations for the 2025/2026 academic session at the University of Nigeria, Nsukka (UNN) will commence on Monday, December 15, 2025, and run through January 17, 2026. With less than two weeks left, the entire campus is now in full “exam mode” — libraries packed 24/7, hostels echoing with group discussions, and the famous UNN night class culture hitting fever pitch.'
'But this year feels different. The Vice-Chancellor, Professor Charles Arizechukwu Igwe, has declared the 2025/2026 exams “the most fortified in UNN history,” rolling out a cocktail of brand-new strategies designed to crush examination malpractice, reward integrity, and leverage technology like never before.'
'The Big Five New Strategies Every Lion Must Know 100% Biometric + Blockchain Verification at Exam Halls'
'Thanks to the newly launched Lions Ledger UNN Blockchain Ecosystem, every student must now pass double verification before entering any exam venue:'
'Live fingerprint scan matched against the blockchain-stored matriculation record.Real-time facial recognition powered by AI cameras at hall entrances.'
'Mismatch = automatic disqualification and referral to the Exam Malpractice Committee — no appeals.Massive CBT Expansion – Over 60% of Courses Now Fully Digital Faculties of Biological Sciences, Physical Sciences, Engineering, Social Sciences, Business Administration, and most General Studies GST courses will write on computers at the ultra-modern Princess Alexandra CBT Centre  and the new Nnamdi Azikiwe Library CBT Wing '          
    },

    {
      'title': 'Faculty Awareness on Birth Right and Abortion',
      'tag': 'Public',
      'image':
      'https://images.unsplash.com/photo-1605084707586-d2bdee1a7105?q=80&w=1016&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'description' : 'UNN Admission Saga 2024/2025: From Merit Triumphs to Supplementary Lifelines – Amidst Storm Clouds of Racketeering Allegations!'
'Nsukka, December 2, 2025 – The University of Nigeria, Nsukka (UNN), Africas intellectual powerhouse and Nigeria first indigenous university, continues to stir the pot in the 2024/2025 admission cycle. What began as a beacon of hope with the primary merit list in late November has evolved into a multi-batch marathon, offering second (and third) chances to thousands of JAMB warriors. Yet, beneath the celebrations, a brewing controversy over alleged racketeering – with whispers of N2 million "slots" for Medicine and Surgery – threatens to tarnish the Eagles Nest storied legacy of meritocracy. As the portal hums with activity, prospective Lions are left navigating a mix of elation, frustration, and calls for transparency from heavyweights like education consultant Alex Onyia.'
    },
    {
      'title': 'Update on students Protest on School fees increase',
      'tag': 'Trending',
      'image':
          'https://images.unsplash.com/photo-1617660707636-6c17e39a67cf?q=80&w=774&auto=format&fit=crop',
    },
    {
      'title': ' Resmuption of the PostGraduate Lectures ',
      'tag': 'Update',
      'image':
        'https://images.unsplash.com/photo-1554457606-ed16c39db884?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'description':  'UNN Holds Landmark Faculty-Wide Sensitization on “Birthright, Bodily Autonomy & Safe Choices” – Breaks Silence on Abortion, Reproductive Rights & Mental Health'
'Nsukka, December 2, 2025 – In what many are already calling the most courageous campus conversation in decades took place today as the University of Nigeria, Nsukka UNN rolled out a university-wide faculty sensitization programme titled Birthright: My Body, My Future”. Organized jointly by the Office of the Dean of Students’ Affairs, the Medical Centre, the Faculty of Law, the Department of Psychology, and the student-led Reproductive Health Advocacy Club (RHAC), the event reached over 18,000 students across all 15 faculties in a single day through simultaneous physical and virtual sessions.'
'For years, abortion and reproductive health remained the unspoken elephant on Nigerian campuses — whispered in hostels, back-alley risks, and silent trauma. Today, UNN shattered that taboo.'
    },
    {
      'title': 'Admission Admission',
      'tag': 'Information',
      'image':
        'https://images.unsplash.com/photo-1732811797813-16f831d5533f?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        'description' : ''
    },
  ];

  @override
  void initState() {
    super.initState();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients || trending.isEmpty) return;
      final nextPage = (_currentActionPage.value + 1) % trending.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _currentActionPage.value = nextPage;
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // 🔍 Dispose search controller
    _currentActionPage.dispose();
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
       leading: const Text('Campus News', 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
        actions: [
          _iconCircle(
              Icons.person, () => Navigator.pushNamed(context, '/profile'))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          children: [
            buildSearchBox(), // 🔍 Search box with functionality
            SizedBox(height: 2.h),
            _sectionHeader('Trending News'),
            const SizedBox(height: 6),
            _trendingPageView(),
            SizedBox(height: 2.h),
            _pageIndicators(),
            const SizedBox(height: 18),
            _sectionHeader('Latest News', actionText: 'See All'),
            const SizedBox(height: 12),
            // 🔍 NEWS LIST WITH SEARCH FILTERING
            _buildLatestNewsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/uploadScreen');
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, size: 35, color: Colors.black),
      ),
    );
  }

  // 🔍 SEARCH BOX WITH FUNCTIONALITY
  Widget buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search news...',
                hintStyle: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔍 LATEST NEWS LIST WITH SEARCH FILTERING
  Widget _buildLatestNewsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("articles")
          .where("status", isEqualTo: "approved")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "No approved articles yet",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          );
        }

        // 🔍 FILTER DOCUMENTS BASED ON SEARCH QUERY
        final filteredDocs = docs.where((doc) {
          if (_searchQuery.isEmpty) return true;
          
          final data = doc.data() as Map<String, dynamic>;
          final title = (data['title'] ?? '').toString().toLowerCase();
          final description = (data['description'] ?? '').toString().toLowerCase();
          final author = (data['author'] ?? '').toString().toLowerCase();
          final tag = (data['tag'] ?? '').toString().toLowerCase();
          
          return title.contains(_searchQuery) ||
                 description.contains(_searchQuery) ||
                 author.contains(_searchQuery) ||
                 tag.contains(_searchQuery);
        }).toList();

        // Show "No results" if filtered list is empty
        if (filteredDocs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "$_searchQuery"',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: filteredDocs.map((doc) {
            return _buildLatestCard(doc);
          }).toList(),
        );
      },
    );
  }

  // 🎯 CARD WIDGET
  Widget _buildLatestCard(DocumentSnapshot doc) {
    final item = doc.data() as Map<String, dynamic>;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ArticleDetailPage(
            article: {
              "title": item["title"] ?? "",
              "description": item["description"] ?? "",
              "image": item["imageUrl"] ?? "",
              "tag": item["tag"] ?? "",
              "author": item["author"] ?? "",
            },
          ),
        ),
      ),
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
                child: Image.network(
                  item['imageUrl'] ?? '',
                  width: 40.w,
                  height: 14.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40.w,
                      height: 14.h,
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white54),
                    );
                  },
                ),
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
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatTimestamp(item['timestamp']),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['title'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(
                            item['authorAvatar'] ?? 'assets/images/App_Logo.png',
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item['author'] ?? "Anonymous",
                          style: TextStyle(color: Colors.grey[300], fontSize: 10),
                        ),
                        const Spacer(),
                        const Icon(Icons.favorite, color: Colors.red, size: 18),
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

  // 📅 FORMAT TIMESTAMP
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'No date';
    
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return 'Invalid date';
    }
    
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }

  Widget _iconCircle(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
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
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/viewAll');
            },
            child: Text(actionText,
                style: const TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _trendingPageView() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: trending.length,
        onPageChanged: (index) {
          _currentActionPage.value = index;
        },
        itemBuilder: (context, index) {
          final item = trending[index];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ArticleDetailPage(article: item))),
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(item['image']!, fit: BoxFit.cover),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.65)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(item['tag'] ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      bottom: 12,
                      right: 14,
                      child: Text(
                        item['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pageIndicators() {
    return ValueListenableBuilder<int>(
      valueListenable: _currentActionPage,
      builder: (context, currentPage, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(trending.length, (i) {
            final isActive = i == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? Colors.grey[900] : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        );
      },
    );
  }
}