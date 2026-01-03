// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileScreen extends StatefulWidget {

//   const ProfileScreen({super.key, });

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Profile')),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : FadeTransition(
//               opacity: _fadeAnimation,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.blueGrey[200],
//                       child: Icon(Icons.person, size: 50, color: Colors.white),
//                     ),
//                     SizedBox(height: 15),
//                     Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Name:',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 5),
//                             TextField(
//                               controller: _nameController,
//                               decoration: InputDecoration(
//                                 labelText: 'Enter your name',
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             ElevatedButton.icon(
//                               onPressed: _updateName,
//                               icon: Icon(Icons.update),
//                               label: Text('Update Name'),
//                             ),
//                             SizedBox(height: 15),
//                             Text(
//                               'Email: $userEmail',
//                               style: TextStyle(
//                                   fontSize: 16, color: Colors.grey[700]),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     SizedBox(height: 20),
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.logout),
//                       label: Text('Log Out'),
//                       onPressed: () async {
//                         await _auth.signOut();
//                         Navigator.pushReplacementNamed(context, '/login');
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _nameController = TextEditingController();

  String userEmail = '';
  String displayName = '';
  bool _isLoading = true;
  bool _darkMode = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward(); // Start animation

    loadUserDetails(); // Load user details
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void loadUserDetails() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        setState(() {
          userEmail = currentUser.email ?? '';
        });

        final userDoc =
            await _db.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          setState(() {
            displayName = userDoc.data()?['name'] ?? '';
            _nameController.text = displayName;
            _isLoading = false;
          });
        } else {
          _showErrorMessage('User details not found.');
        }
      } else {
        _showErrorMessage('User is not logged in.');
      }
    } catch (e) {
      _showErrorMessage('Error loading user details: $e');
    }
  }

  void _updateName() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _db.collection('users').doc(currentUser.uid).update({
          'name': _nameController.text.trim(),
        });
        setState(() {
          displayName = _nameController.text.trim();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Name updated successfully!'),
        ));
      }
    } catch (e) {
      _showErrorMessage('Error updating name: $e');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  bool nightMode = false;
  bool notifications = true;
  bool emailNotifications = true;
  bool socialMediaConnected = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyleSub = GoogleFonts.poppins(fontSize: 13, color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Profile',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white,))
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.h),
                  children: [
                    // Profile card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$userEmail',
                                    style: TextStyle(color: Colors.white)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    _smallStat('2', 'Posts'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Settings container
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Night mode row (custom looking like the reference)

                          // Notifications toggle
                          SwitchListTile.adaptive(
                            thumbColor: WidgetStatePropertyAll(Colors.black),
                            trackColor: WidgetStatePropertyAll(Colors.green),
                            contentPadding: EdgeInsets.zero,
                            title: Text('Notifications',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            subtitle: Text('Push notifications and updates',
                                style: textStyleSub),
                            value: notifications,
                            onChanged: (v) => setState(() => notifications = v),
                            secondary: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.green,
                            ),
                          ),

                          // Email row with subtitle
                         _isLoading?const Center(child: CircularProgressIndicator(color: Colors.white,)) :
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.email_outlined,
                                color: Colors.green),
                            title: Text('Email',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            subtitle: Text(' $userEmail', style: textStyleSub),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  thumbColor:
                                      WidgetStatePropertyAll(Colors.black),
                                  trackColor:
                                      WidgetStatePropertyAll(Colors.green),
                                  value: emailNotifications,
                                  onChanged: (v) =>
                                      setState(() => emailNotifications = v),
                                  activeColor: theme.primaryColor,
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),

                          const Divider(height: 20),

                          // Logout
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.logout,
                                color: Colors.redAccent),
                            title: Text('Logout',
                                style: GoogleFonts.poppins(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600)),
                            onTap: () async {
                              await _auth.signOut();
                              setState(() => _isLoading = true);

                              await _auth.signOut();

                              // wait 2 seconds
                              await Future.delayed(Duration(seconds: 2));

                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Small footer / version
                    Center(
                      child: Text('App version 1.0.0', style: textStyleSub),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _smallStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
