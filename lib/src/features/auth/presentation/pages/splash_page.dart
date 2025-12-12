import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:neuconnectz_dynea/src/core/barrels/auth_barrel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  int _animationStep = 0;
  late AnimationController _rotationController;
  late AnimationController _sizeController;
  late AnimationController _positionController;
  late AnimationController _textController;
  late AnimationController _finalExpandController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _finalExpandAnimation;
  late Animation<double> _sizeDuringRotation;

  var animationDuration = 700;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        statusBarIconBrightness: Brightness.light, // white icons
      ),
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 45).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    final sizeTween = Tween<double>(begin: 80, end: 120);
    _sizeDuringRotation = sizeTween.animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.easeInOut),
    );

    // Position animation controller
    _positionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(100, 0),
    ).animate(
      CurvedAnimation(parent: _positionController, curve: Curves.easeInOut),
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Final expand animation controller
    _finalExpandController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _finalExpandAnimation = Tween<double>(begin: 1.0, end: 70.0).animate(
      CurvedAnimation(parent: _finalExpandController, curve: Curves.easeInOut),
    );

    // Listen for the end of the final animation
    _finalExpandController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkLaunchAndLoginStatus();
      }
    });

    // Start the animation sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    // Initial delay
    Timer(Duration(milliseconds: 200), () {
      setState(() {
        _animationStep = 1;
      });

      // Step 2: Rotate the square
      Timer(Duration(milliseconds: animationDuration), () {
        setState(() {
          _animationStep = 2;
        });
        _rotationController.forward();

        // Step 3: Diamond shape
        Timer(Duration(milliseconds: animationDuration), () {
          setState(() {
            _animationStep = 3;
          });

          // Step 4: Shrink to circle
          Timer(Duration(milliseconds: animationDuration), () {
            setState(() {
              _animationStep = 4;
            });
            _sizeController.forward();

            // Step 5: Move circle and show text
            Timer(Duration(milliseconds: animationDuration), () {
              setState(() {
                _animationStep = 5;
              });
              _positionController.forward();
              _textController.forward();

              // Final step: Expand to full screen
              Timer(Duration(milliseconds: animationDuration), () {
                _finalExpandController.forward();
                // Navigation is now handled by the build method when _navigateToLogin becomes true
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _sizeController.dispose();
    _positionController.dispose();
    _textController.dispose();
    _finalExpandController.dispose();
    super.dispose();
  }

  void _checkLaunchAndLoginStatus() async {
    if (!mounted) return;
    final token = AppPreferences().getAccessToken();
    final user = AppPreferences().user;
    log("Token is $token");
    log("User is $user");
    if (token != null && user != null) {
      log(user.toString());
      context.read<UserCubit>().setUser(user);
      context.goNamed(AppRoutes.dashboard);
    } else {
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      body: Stack(children: [Center(child: _buildAnimationStep())]),
    );
  }

  Widget _buildAnimationStep() {
    switch (_animationStep) {
      case 0:
        // Empty blue screen
        return const SizedBox.shrink();

      case 1:
        // Rounded container appears from bottom
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 300, end: 0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
        );
      case 2:
        return AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            final size = _sizeDuringRotation.value;
            return Transform.rotate(
              angle: _rotationAnimation.value * 3.14159 / 180,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
        );

      case 3:
        return AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            final size = _sizeDuringRotation.value;
            return Transform.rotate(
              angle: 45 * 3.14159 / 180,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
        );

      case 4:
        // Shrink to circle
        return AnimatedBuilder(
          animation: _sizeController,
          builder: (context, child) {
            return Transform.scale(
              scale: _sizeAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            );
          },
        );

      case 5:
        // Text and circle
        return Stack(
          alignment: Alignment.center,
          children: [
            // Text animation
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Transform.translate(
                    offset: Offset(-50 * (1 - _textOpacityAnimation.value), 0),
                    child: Image.asset(
                      AppAssets.logoTwo,
                      height: 36.h,
                      width: 170.w,
                    ),
                  ),
                );
              },
            ),

            // Circle animation
            AnimatedBuilder(
              animation: _positionController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _finalExpandController,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: _positionAnimation.value,
                      child: Transform.scale(
                        scale: _finalExpandAnimation.value,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}


