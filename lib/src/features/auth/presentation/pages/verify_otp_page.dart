import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/barrels/auth_barrel.dart';

class VerifyOtpPage extends StatefulWidget {
  final String email;
  final VerificationType verificationType;
  final UserModel? user;

  const VerifyOtpPage({
    super.key,
    required this.email,
    required this.verificationType,
    this.user,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _timerSeconds = 60;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  void _startTimer() {
    _timerSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state is VerifyOtpForForgetPasswordSuccess) {
          if (state.response.data == true) {
            context.pushReplacementNamed(
              AppRoutes.resetPassword,
              extra: widget.email,
            );
          }
        } else if (state is AuthVerifyOtpFailure) {
          CustomToast.error(context, state.message);
        }
        if (state is VerifyOtpFor2FASuccess) {
          if (state.response.data?.isVerified == true) {
            CustomToast.success(context, "OTP verified");
            context.goNamed(AppRoutes.dashboard);
          } else {
            CustomToast.error(context, "OTP not verified");
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AuthVerifyOtpLoading,
          child: Scaffold(
            backgroundColor: AppPalette.scaffoldBackgroundColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  80.verticalSpace,
                  _logoWidget(),
                  33.verticalSpace,
                  _formWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _formWidget() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewConnectLogoWidget(),
                _verifyOtpText(),
                4.verticalSpace,
                _instructionsText(),
                20.verticalSpace,
                _otpTextField(),
                10.verticalSpace,
                _verifyCodeButton(),
                17.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  FadeTransition _verifyOtpText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomText(
          text: AppTexts.verifyOtp,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.darkGreyColor,
        ),
      ),
    );
  }

  Widget _instructionsText() {
    return CustomText(
      text:
          widget.verificationType == VerificationType.forgetPassword
              ? "We sent a mail to ${widget.email}.Enter 4 digits code that mentioned in the email"
              : AppTexts.enterOtpLockKeyzInstructions,
      fontSize: 15.sp,
      maxLines: 5,
      color: AppPalette.hintColor,
      textAlign: TextAlign.start,
    );
  }

  Widget _otpTextField() {
    bool isVerificationTypeForget =
        widget.verificationType == VerificationType.forgetPassword;
    return Column(
      children: [
        PinCodeTextField(
          appContext: context,
          length: isVerificationTypeForget ? 4 : 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: AppPinTheme.getTheme(
            context,
            boxSize: isVerificationTypeForget ? 50 : 47,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          cursorColor: context.primaryColor,
          keyboardType: TextInputType.number,
          mainAxisAlignment: MainAxisAlignment.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onCompleted: (v) {
            _otpController.text = v;
            //_isButtonEnabled = true;
            // setState(() {});
          },
          onChanged: (value) {
            _otpController.text = value;
            _isButtonEnabled =
                widget.verificationType == VerificationType.forgetPassword
                    ? value.length == 4
                    : value.length == 6;
            setState(() {});
          },
        ),
        if (widget.verificationType == VerificationType.forgetPassword) ...[
          10.verticalSpace,
          _didNotReceiveCodeWidget(),
        ],
      ],
    );
  }

  Widget _didNotReceiveCodeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppTexts.didntReceiveCode,
          fontSize: 14.sp,
          color: AppPalette.hintColor,
        ),
        if (_timerSeconds > 0)
          CustomText(
            text: ' (${_formatTime(_timerSeconds)})',
            fontSize: 14.sp,
            color: AppPalette.hintColor,
            fontWeight: FontWeight.bold,
          )
        else
          TextButton(
            onPressed: _resendOtp,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            child: CustomText(
              text: AppTexts.resend,
              fontSize: 14.sp,
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _verifyCodeButton() {
    return CustomButton(
      text: AppTexts.verifyCode,
      textColor: _isButtonEnabled == true ? Colors.white : AppPalette.greyColor,
      color:
          _isButtonEnabled == true
              ? context.primaryColor
              : AppPalette.lightGreyColor,
      onPressed: () {
        if (_isButtonEnabled == true) {
          _onSubmit();
        }
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.unfocusFocusScope();
      if (widget.verificationType == VerificationType.twoFactorAuthentication) {
        _verifyTwoFactorOtpEvent();
      } else if (widget.verificationType == VerificationType.forgetPassword) {
        _verifyForgetPasswordOtpEvent();
      }
    }
  }

  Future<void> _verifyTwoFactorOtpEvent() async {
    String? otp = _otpController.text.trim();
    String? deviceId = await Utils.getDeviceId();
    if (!mounted) return;
    context.read<AuthenticationBloc>().add(
      VerifyOtpEvent(
        params: TwoFactorAuthenticationRequestModel(
          totp: otp,
          numOfDigits: otp.length.toString(),
          secretKey: widget.user?.secretKey,
          timeLimitInSec: '30',
          deviceId: deviceId,
        ),
        user: widget.user,
      ),
    );
  }

  Future<void> _verifyForgetPasswordOtpEvent() async {
    String? otp = _otpController.text.trim();
    context.read<AuthenticationBloc>().add(
      VerifyOtpForForgetPasswordEvent(otp: otp, email: widget.email),
    );
  }

  void _resendOtp() {
    if (widget.verificationType == VerificationType.forgetPassword) {
      context.read<AuthenticationBloc>().add(
        ForgetPasswordRequestedEvent(
          ForgetPasswordRequestModel(email: widget.email, deviceId: ''),
        ),
      );
      setState(() {
        _timerSeconds = 60;
      });
      _startTimer();
    }
  }

  FadeTransition _logoWidget() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomLogoHeader(),
      ),
    );
  }
}


