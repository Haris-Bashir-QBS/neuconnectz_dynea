import 'package:flutter/material.dart';

import '../../../../core/barrels/auth_barrel.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;
  const ResetPasswordPage({super.key, this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.scaffoldBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: context.select<AuthenticationBloc, bool>(
          (bloc) => bloc.state is ResetPasswordLoading,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _form(),
        ),
      ),
    );
  }

  Widget _form() {
    return BlocConsumer<AuthenticationBloc, AuthState>(
      listener: _listener,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              80.verticalSpace,
              _logoWidget(),
              40.verticalSpace,
              _fromWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _fromWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NewConnectLogoWidget(),
                  _setANewPAssword(),
                  10.verticalSpace,
                  _instructionText(),
                  30.verticalSpace,
                  _newPasswordTextField(),
                  20.verticalSpace,
                  _confirmPasswordTextField(),
                  40.verticalSpace,
                  _resetPasswordButton(),
                  10.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listener(context, state) {
    if (state is ResetPasswordFailure) {
      CustomToast.error(context, state.message);
    }
    if (state is ResetPasswordSuccess) {
      if (state.response.data == true) {
        _successDialog(context);
      }
    }
  }

  void _successDialog(BuildContext context) {
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: true,
      title: AppTexts.success,
      message: AppTexts.passwordResetSuccessMessage,
      primaryButtonText: AppTexts.continuee,
      onPrimaryTap: () {
        // _passwordController.clear();
        // _confirmPasswordController.clear();
        context.goNamed(AppRoutes.login);
      },
    );
  }

  Widget _resetPasswordButton() {
    return CustomButton(
      text: AppTexts.resetPassword,
      radius: 10.r,
      onPressed: _onResetPressed,
    );
  }

  Widget _confirmPasswordTextField() {
    return CustomTextFormField(
      label: AppTexts.confirmPassword,
      hint: AppTexts.reEnterPassword,
      controller: _confirmPasswordController,
      isPassword: true,
      validator: AppValidators.combine([
        AppValidators.required(),
        AppValidators.minLength(6),
        (value) {
          if (value != _passwordController.text) {
            return AppTexts.passwordsDoNotMatch;
          }
          return null;
        },
      ]),
    );
  }

  Widget _newPasswordTextField() {
    return CustomTextFormField(
      label: AppTexts.password,
      hint: AppTexts.enterNewPassword,
      controller: _passwordController,
      isPassword: true,
      validator: AppValidators.combine([
        AppValidators.required(),
        AppValidators.minLength(6),
      ]),
    );
  }

  CustomText _instructionText() {
    return CustomText(
      text: AppTexts.resetPasswordInstructionTwo,
      maxLines: 3,
      fontSize: 15.sp,
      color: AppPalette.hintColor,
    );
  }

  CustomText _setANewPAssword() {
    return CustomText(
      text: AppTexts.setANewPassword,
      fontSize: 21.sp,
      fontWeight: FontWeight.bold,
      color: AppPalette.darkGreyColor,
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

  void _onResetPressed() {
    //_successDialog(context);
    if (_formKey.currentState!.validate()) {
      context.unfocusFocusScope();
      _resetPasswordEvent();
    }
  }

  void _resetPasswordEvent() {
    context.read<AuthenticationBloc>().add(
      ResetPasswordRequestedEvent(
        ResetPasswordRequestModel(
          email: widget.email ?? '',
          password: _passwordController.text.trim(),
        ),
      ),
    );
  }
}


