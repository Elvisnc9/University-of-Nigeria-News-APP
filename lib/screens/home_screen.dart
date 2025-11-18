// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {

//

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Student Hub',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         actions: [
//           _buildProfileAvatar(),
//           const SizedBox(width: 12),
//           IconButton(
//             icon: const Icon(Icons.logout, size: 28),
//             onPressed: () async {
//               await _auth.signOut();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _onRefresh,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildWelcomeSection(),
//               const SizedBox(height: 30),
//               _buildQuickActionsHeader(),
//               const SizedBox(height: 20),
//               Expanded(child: _buildActionGrid()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//

//   Widget _buildWelcomeSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '👋 Welcome back,',
//           style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           displayName.isNotEmpty ? displayName : 'Student',
//           style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.deepPurple),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           userEmail,
//           style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//               fontStyle: FontStyle.italic),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActionsHeader() {
//     return const Text(
//       'Quick Access',
//       style: TextStyle(
//           fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//     );
//   }

//   Widget _buildActionGrid() {
//     return GridView.count(
//       crossAxisCount: 2,
//       mainAxisSpacing: 20,
//       crossAxisSpacing: 20,
//       childAspectRatio: 1.1,
//       children: [
//         _buildActionCard(
//             icon: Icons.menu_book_rounded,
//             title: 'Study Materials',
//             color: Colors.deepPurple,
//             route: '/materials'),
//         _buildActionCard(
//             icon: Icons.help_center_rounded,
//             title: 'Help Desk',
//             color: Colors.blue,
//             route: '/help'),
//         _buildActionCard(
//             icon: Icons.forum_rounded,
//             title: 'Chat',
//             color: Colors.green,
//             route: '/chat'),
//       ],
//     );
//   }

//   Widget _buildActionCard({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required String route,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(15),
//         onTap: () => Navigator.pushNamed(context, route),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [color.withOpacity(0.9), color.withOpacity(0.7)]),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 42, color: Colors.white),
//                 const SizedBox(height: 15),
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = [
    'All',
    'My Department',
    'My Courses',
    'Recently Added',
    'Most Downloaded'
  ];
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String userEmail = '';
  String displayName = '';

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() => userEmail = currentUser.email ?? '');

      final userDoc = await _db.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() => displayName = userDoc.data()?['name'] ?? '');
      }
    }
  }

  Future<void> _onRefresh() async => await loadUserDetails();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 54,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 0, top: 6),
          child: Image.asset(
            "assets/icons/ILogo.png", // Replace with your logo asset
            width: 36,
            height: 36,
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              filled: true,
              fillColor: Color(0xFFF3F6FC),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              hintText: "Search courses, topic, file...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [_buildProfileAvatar()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _filters.length,
                  (i) => Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_filters[i],
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      selected: _selectedFilter == i,
                      selectedColor: Color(0xFF156BFF),
                      backgroundColor: Color(0xFFF5F7FA),
                      labelStyle: TextStyle(
                        color:
                            _selectedFilter == i ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) => setState(() => _selectedFilter = i),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Resource List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                // Resource Card 1
                _resourceCard(
                  image:
                      "assets/icons/ImageCalculus.png", // Replace with your course image
                  fileType: "PDF",
                  title: "Calculus II Integration Techniques",
                  code: "MTH102",
                  author: "Michael Rodriguez",
                  timeAgo: "1 day ago",
                  rating: 4.8,
                  ratings: 11303,
                  fileSize: "15MB",
                  bookmarked: false,
                ),
                SizedBox(height: 16),
                // Resource Card 2
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/uploadScreen');
        },
        backgroundColor: Color(0xFF156BFF),
        child: Icon(Icons.add, color: Colors.white, size: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bottomNavItem(Icons.home_rounded, "Home", selected: true),
              _bottomNavItem(Icons.chat_bubble_rounded, "Message"),
              SizedBox(width: 48), // Space for FAB
              _bottomNavItem(Icons.bookmark, "Bookmarks"),
              _bottomNavItem(Icons.person_rounded, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resourceCard({
    required String image,
    required String fileType,
    required String title,
    required String code,
    required String author,
    required String timeAgo,
    required double rating,
    required int ratings,
    required String fileSize,
    required bool bookmarked,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and label
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image,
                    height: 84,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      fileType,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            SizedBox(height: 5),
            Text(code,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600])),
            // Author, time, rating, size
            SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage(
                      "assets/icons/applogo.png"), // Replace as needed
                ),
                SizedBox(width: 7),
                Expanded(
                  child: Text(
                    author,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  "• $timeAgo",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 17),
                SizedBox(width: 2),
                Text("$rating",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                SizedBox(width: 3),
                Text(
                  "($ratings people rated)",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Spacer(),
                Icon(Icons.insert_drive_file,
                    size: 18, color: Colors.grey[400]),
                Text(" $fileSize",
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 11),
            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF156BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 11),
                    ),
                    onPressed: () {},
                    child: Text("Download",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.share, color: Color(0xFF575D6A)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    bookmarked ? Icons.download : Icons.bookmark_border,
                    color: bookmarked ? Color(0xFF156BFF) : Color(0xFF575D6A),
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String label, {bool selected = false}) {
    return Expanded(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? Color(0xFF156BFF) : Colors.black),
              Text(label,
                  style: TextStyle(
                    color: selected ? Color(0xFF156BFF) : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/profile'),
      child: CircleAvatar(
        backgroundColor: Color(0xFF156BFF),
        child: Text(
          userEmail.isNotEmpty ? userEmail[0].toUpperCase() : '?',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
