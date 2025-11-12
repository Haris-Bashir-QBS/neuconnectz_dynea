import 'package:flutter/material.dart';

import '../../../../core/barrels/auth_barrel.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: context.select<AuthenticationBloc, bool>(
            (bloc) => bloc.state is ForgetPasswordLoading,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _forgetPasswordForm(),
          ),
        ),
      ),
    );
  }

  Widget _forgetPasswordForm() {
    return BlocConsumer<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgetPasswordFailure) {
          CustomToast.error(context, state.message);
        }
        if (state is ForgetPasswordSuccess) {
          if (state.response.data == true) {
            CustomToast.success(context, state.response.message);
            _navigateToOtpVerificationPage(_emailController.text.trim());
          }
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              30.verticalSpace,
              _logoWidget(),
              33.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewConnectLogoWidget(),
                    _forgetPasswordText(),
                    _resetInstruction(),
                    20.verticalSpace,
                    _emailTextField(),
                    40.verticalSpace,
                    _sendResetLinkButton(),
                    17.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  FadeTransition _resetInstruction() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomText(
          text: AppTexts.resetInstructions,
          fontSize: 15.sp,
          color: AppPalette.hintColor,
          textAlign: TextAlign.center,
          maxLines: 10,
        ),
      ),
    );
  }

  FadeTransition _forgetPasswordText() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomText(
          text: AppTexts.forgetPassword,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.darkGreyColor,
        ),
      ),
    );
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

  void _navigateToOtpVerificationPage(String email) {
    context.pushNamed(
      AppRoutes.verifyOtp,
      extra: VerifyCodeParams(
        type: VerificationType.forgetPassword,
        email: email,
      ),
    );
  }

  Widget _emailTextField() {
    return CustomTextFormField(
      label: AppTexts.yourEmail,
      hint: AppTexts.enterEmail,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      validator: AppValidators.combine([
        AppValidators.email(),
        //  AppValidators.email(),
      ]),
    );
  }

  Widget _sendResetLinkButton() {
    return CustomButton(
      text: AppTexts.resetPassword,
      onPressed: _onSubmit,
      radius: 10.r,
    );
  }

  void _onSubmit() async {
    //context.pushNamed(AppRoutes.resetPassword);
    if (_formKey.currentState!.validate()) {
      context.unfocusFocusScope();
      String? deviceId = await Utils.getDeviceId();
      if (!mounted) return;
      _forgetPasswordEvent(deviceId);
    }
  }

  /// ======================================= Events ===================================
  void _forgetPasswordEvent(String? deviceId) {
    context.read<AuthenticationBloc>().add(
      ForgetPasswordRequestedEvent(
        ForgetPasswordRequestModel(
          email: _emailController.text.trim(),
          deviceId: deviceId ?? "",
        ),
      ),
    );
  }
}
