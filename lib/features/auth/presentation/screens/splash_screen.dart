import 'package:flutter/material.dart';
import 'package:roomsync/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _taglineFadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 1200)
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
 
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );
 
    _taglineFadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceGray,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),
                      FadeTransition(
                        opacity: _taglineFadeAnim,
                        child: _buildTagline(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _taglineFadeAnim,
                child: Column(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.textCharcoal.withAlpha(128),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textCharcoal.withAlpha(77),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: 82,
      color: Colors.transparent,
      margin: EdgeInsets.only(right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage('assets/images/icon_transparent.png'),
                fit: BoxFit.contain
              )
            ),
          ),
          Text(
            'RoomSync',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textCharcoal,
              letterSpacing: -0.5
            ),
          )
        ],
      )
    );
  }

  Widget _buildTagline() {
    return Text(
      'Synchronize Your Workspace',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textCharcoal,
        letterSpacing: 0.5
      ),
    );
  }
}