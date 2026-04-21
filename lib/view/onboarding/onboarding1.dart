import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:spendigo/config/Colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  late PageController _pageController;
  late int _currentPage;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/onboard1.png',
      'title': 'Take Control of Your Spending',
      'description':
          'Track your income and expenses easily and understand where your money goes.',
    },
    {
      'image': 'assets/onboard2.png',
      'title': 'Manage Your Wallets',
      'description':
          'Add multiple wallets and keep all your finances organized in one place.',
    },
    {
      'image': 'assets/onboard3.png',
      'title': 'Plan Smarter Budgets',
      'description':
          'Set budgets, control spending, and reach your financial goals faster.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          child: SvgPicture.asset(
                            'assets/onboarding_bg.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 10.h,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Image.asset(
                            page['image']!,
                            width: size.width * 0.85,
                            height: size.height * 0.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 28.h),

            /// TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Text(
                _pages[_currentPage]['title']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),

            SizedBox(height: 6.h),

            /// DESCRIPTION
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Text(
                _pages[_currentPage]['description']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF5F6D78),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),

            SizedBox(height: 28.h),

            /// BOTTOM CONTROLS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          )
                        : null,
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.sp,
                      color: _currentPage > 0
                          ? const Color(0xFF6F8A83)
                          : Colors.transparent,
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _pages.length,
                      (index) => Row(
                        children: [
                          _buildDot(active: index == _currentPage),
                          if (index < _pages.length - 1) SizedBox(width: 8.w),
                        ],
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _currentPage < _pages.length - 1
                        ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          )
                        : () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('onboarding_completed', true);
                            Get.offNamed(AppRoutesName.signIn);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool active}) {
    return Container(
      width: active ? 20.w : 10.w,
      height: 10.h,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : const Color(0xFFD2E3DD),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
