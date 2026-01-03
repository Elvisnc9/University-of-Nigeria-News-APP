import 'package:flutter/material.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({super.key});

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPageContent> _pages = [
    _OnboardPageContent(
      image: 'assets/images/App_Logo.png',
      title: 'Access Quality Information',
      subtitle:
          'Stay Updated With The lastest News, Events, and Informations by fellow students.',
    ),
    _OnboardPageContent(
      image: 'assets/images/onboardingg.png',
      title: 'Stay Informed',
      subtitle:
          'Track your learning, and stay ahead with personalized study tools.',
    ),
    _OnboardPageContent(
      image: 'assets/images/onbooaarding.png',
      title: 'Join the Community',
      subtitle:
          'Connect with fellow students, ask questions, and collaborate on academic goals.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    } else {
      // Perform sign in/navigation
      // For now, display a snackbar

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Skip anywhere you want, e.g., jump to last page
                    _controller.animateToPage(_pages.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease);
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // PageView for onboarding screens
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, idx) => _OnboardingPage(
                    content: _pages[idx],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              // Page Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (idx) {
                  bool isActive = idx == _currentPage;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: isActive ? 28 : 8,
                    height: 6,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.grey,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              SizedBox(height: 5.h),
              // Next or Sign in button
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 6.w),
                child: SizedBox(
                  height: 52,   
                  
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Sign in' : 'Next',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPageContent {
  final String image;
  final String title;
  final String subtitle;
  const _OnboardPageContent({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardPageContent content;
  const _OnboardingPage({required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The main image
        SizedBox(
          height: 350,
          child: Center(
            child: Image.asset(
              content.image,
              width: 600,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            content.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            content.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
