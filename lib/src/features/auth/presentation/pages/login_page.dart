import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/barrels/auth_barrel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final FocusNode _passwordFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });

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

  void _clearFormFields() {
    _emailController.clear();
    _passwordController.clear();
    if (_formKey.currentState != null) {
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppPalette.scaffoldBackgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: context.select<AuthenticationBloc, bool>(
            (bloc) => bloc.state is AuthLoading,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _loginForm(),
                  ),
                ),
              ),
              if (context.bottomInsetsZero) ...[
                _poweredByWidget(),
                32.verticalSpace,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocConsumer<AuthenticationBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          CustomToast.error(context, state.message);
        }
        if (state is AuthSuccess) {
          if (state.user.isTotp != true) {
            _navigateToDashboardPage(context);
          } else {
            _navigateToOtpVerificationPage(context, state);
          }
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              38.verticalSpace,
              _logoWidget(),
              //50.verticalSpace,
              SizedBox(height: 0.06.sh),
              _formWidget(context),
              20.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget _poweredByWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: AppTexts.poweredBy,
          color: AppPalette.greyColor,
          fontWeight: FontWeight.w400,
        ),
        5.horizontalSpace,
        Image.asset(AppAssets.qbsLogo, width: 65.w, height: 20.h),
      ],
    );
  }

  void _navigateToDashboardPage(BuildContext context) {
    context.goNamed(AppRoutes.dashboard);
  }

  Widget _formWidget(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //   32.verticalSpace,
              NewConnectLogoWidget(),
              //   22.verticalSpace,
              _loginTitle(),
              4.verticalSpace,
              _welcomeText(),
              32.verticalSpace,
              _emailTextField(),
              16.verticalSpace,
              _passwordTextField(),
              30.verticalSpace,
              _loginButton(),
              20.verticalSpace,
              _forgetPasswordNavigationLink(context),
              32.verticalSpace,
              // Spacer(),

              // _signupNavigationText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _forgetPasswordNavigationLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _clearFormFields();
        setState(() {});
        context.pushNamed(AppRoutes.forgotPassword);
      },
      child: Center(
        child: CustomText(
          text: "${AppTexts.forgetPassword}?",
          color: context.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  void _navigateToOtpVerificationPage(BuildContext context, AuthSuccess state) {
    context.pushNamed(
      AppRoutes.verifyOtp,
      extra: VerifyCodeParams(
        type: VerificationType.twoFactorAuthentication,
        user: UserModel.fromEntity(state.user),
      ),
    );
  }

  FadeTransition _logoWidget() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: ClientLogo()),
    );
  }

  Widget _loginButton() {
    return CustomButton(
      color: context.primaryColor,
      text: AppTexts.signIn,
      onPressed: _onLogin,
      radius: 10.r,
    );
  }

  Widget _passwordTextField() {
    return CustomTextFormField(
      label: AppTexts.password,
      hint: AppTexts.enterPassword,
      focusNode: _passwordFocusNode,
      isPassword: true,
      controller: _passwordController,
      validator: AppValidators.combine([AppValidators.required()]),
    );
  }

  Widget _emailTextField() {
    return CustomTextFormField(
      label: AppTexts.emailId,
      hint: AppTexts.enterEmail,
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      controller: _emailController,
      validator: AppValidators.combine([AppValidators.email()]),
    );
  }

  Widget _loginTitle() {
    return GestureDetector(
      onTap: () {
        _fillMockCredentials();
      },
      child: CustomText(
        text: AppTexts.signIn,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppPalette.darkGreyColor,
      ),
    );
  }

  void _fillMockCredentials() {
    if (kDebugMode) {
      _emailController.text = "harisbashirdev@gmail.com";
      _passwordController.text = "Dynea!23";
    }
  }

  Widget _welcomeText() {
    return CustomText(
      text: AppTexts.welcomeToNeuConnect,
      fontSize: 17.sp,
      fontWeight: FontWeight.w400,
      color: AppPalette.hintColor,
    );
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.unfocusFocusScope();
      //context.pushNamed(AppRoutes.dashboard);
      _loginEvent();
    }
  }

  void _loginEvent() {
    context.read<AuthenticationBloc>().add(
      AuthLoginEvent(
        params: LoginRequestModel(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
